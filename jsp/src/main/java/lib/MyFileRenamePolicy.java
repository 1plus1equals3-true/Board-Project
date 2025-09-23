package lib;

import com.oreilly.servlet.multipart.FileRenamePolicy;
import java.io.File;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.UUID;

public class MyFileRenamePolicy implements FileRenamePolicy {

    @Override
    public File rename(File f) {
        // 기존 파일명
        String originalFileName = f.getName();
        // 확장자 추출
        String ext = "";
        int dot = originalFileName.lastIndexOf(".");
        if (dot != -1) {
            ext = originalFileName.substring(dot);
        }

        // 새로운 파일명 생성 (예: yyyyMMddHHmmss + UUID + 확장자)
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        String newName = sdf.format(new Date()) + "_" + UUID.randomUUID().toString() + ext;

        // 새로운 파일 객체 생성 후 반환
        File newFile = new File(f.getParent(), newName);
        return newFile;
    }
}