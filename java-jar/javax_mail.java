import java.io.File;
import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.Message.RecipientType;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

public class JavaMailSend {
    private MimeMessage message;
    private Session session;
    private Transport transport;
    private String mailHost = "smtp.163.com";
    private String sender_username = "foobar@163.com";
    private String sender_password = "password";
    private Properties properties = new Properties();

    public JavaMailSend(boolean debug) {
        this.session = Session.getInstance(this.properties);
        this.session.setDebug(debug);
        this.message = new MimeMessage(this.session);
    }

    public void doSendHtmlEmail(String subject, String sendHtml, String receiveUser, String[] cs) {
        try {
            InternetAddress e = new InternetAddress(this.sender_username);
            this.message.setFrom(e);
            InternetAddress to = new InternetAddress(receiveUser);
            this.message.setRecipient(RecipientType.TO, to);
            if(null != cs && cs.length > 0) {
                new InternetAddress();
                InternetAddress[] multipart = InternetAddress.parse(this.getMailList(cs));
                this.message.setRecipients(RecipientType.CC, multipart);
            }

            this.message.setSubject(subject, "text/html;charset=UTF-8");
            MimeMultipart multipart1 = new MimeMultipart();
            MimeBodyPart contentPart = new MimeBodyPart();
            contentPart.setContent(sendHtml, "text/html;charset=UTF-8");
            multipart1.addBodyPart(contentPart);
            this.message.setContent(multipart1);
            this.message.saveChanges();
            this.transport = this.session.getTransport("smtp");
            this.transport.connect(this.mailHost, this.sender_username, this.sender_password);

            try {
                Thread.sleep(2000L);
            } catch (InterruptedException var18) {
                var18.printStackTrace();
            }

            this.transport.sendMessage(this.message, this.message.getAllRecipients());
        } catch (Exception var19) {
            throw new RuntimeException("收件人不存在");
        } finally {
            if(this.transport != null) {
                try {
                    this.transport.close();
                } catch (MessagingException var17) {
                    var17.printStackTrace();
                }
            }

        }

    }

    public void doSendHtmlEmail_attachment(String subject, String sendHtml, String receiveUser, File attachment, String[] cs) {
        try {
            InternetAddress e = new InternetAddress(this.sender_username);
            this.message.setFrom(e);
            InternetAddress to = new InternetAddress(receiveUser);
            this.message.setRecipient(RecipientType.TO, to);
            if(null != cs && cs.length > 0) {
                new InternetAddress();
                InternetAddress[] multipart = InternetAddress.parse(this.getMailList(cs));
                this.message.setRecipients(RecipientType.CC, multipart);
            }

            this.message.setSubject(subject);
            MimeMultipart multipart1 = new MimeMultipart();
            MimeBodyPart contentPart = new MimeBodyPart();
            contentPart.setContent(sendHtml, "text/html;charset=UTF-8");
            multipart1.addBodyPart(contentPart);
            if(attachment != null) {
                MimeBodyPart attachmentBodyPart = new MimeBodyPart();
                FileDataSource source = new FileDataSource(attachment);
                attachmentBodyPart.setDataHandler(new DataHandler(source));
                attachmentBodyPart.setFileName(MimeUtility.encodeWord(attachment.getName()));
                multipart1.addBodyPart(attachmentBodyPart);
            }

            this.message.setContent(multipart1);
            this.message.saveChanges();
            this.transport = this.session.getTransport("smtp");
            this.transport.connect(this.mailHost, this.sender_username, this.sender_password);
            this.transport.sendMessage(this.message, this.message.getAllRecipients());
        } catch (Exception var20) {
            var20.printStackTrace();
        } finally {
            if(this.transport != null) {
                try {
                    this.transport.close();
                } catch (MessagingException var19) {
                    var19.printStackTrace();
                }
            }

        }

    }

    private String getMailList(String[] mailArray) {
        StringBuffer toList = new StringBuffer();
        int length = mailArray.length;
        if(mailArray != null && length < 2) {
            toList.append(mailArray[0]);
        } else {
            for(int i = 0; i < length; ++i) {
                toList.append(mailArray[i]);
                if(i != length - 1) {
                    toList.append(",");
                }
            }
        }

        return toList.toString();
    }

    public static void main(String[] args) {
        JavaMailSend se = new JavaMailSend(false);
        se.doSendHtmlEmail("测试邮件", "测试邮件", "foobar@155.com", new String[]{"barfoo@144.com"});
    }
}
