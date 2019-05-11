package com.system.po;

import org.apache.poi.xssf.usermodel.XSSFCellStyle;

import java.io.Serializable;

public class ExcelBean implements Serializable {

    private String headTextName; //列头名（标题）
    private String propertyName; //对应字段名
    private Integer cols;  //合并单元格数
    private XSSFCellStyle cellStyle;

    public XSSFCellStyle getCellStyle() {
        return cellStyle;
    }

    public void setCellStyle(XSSFCellStyle cellStyle) {
        this.cellStyle = cellStyle;
    }

    public ExcelBean(){ }

    public ExcelBean(String headTextName, String propertyName) {
        this.headTextName = headTextName;
        this.propertyName = propertyName;
    }

    public ExcelBean(String headTextName, String propertyName, Integer cols){
        this.propertyName = propertyName;
        this.headTextName = headTextName;
        this.cols = cols;
    }

    public String getHeadTextName() {
        return headTextName;
    }

    public void setHeadTextName(String headTextName) {
        this.headTextName = headTextName;
    }

    public String getPropertyName() {
        return propertyName;
    }

    public void setPropertyName(String propertyName) {
        this.propertyName = propertyName;
    }

    public Integer getCols() {
        return cols;
    }

    public void setCols(Integer cols) {
        this.cols = cols;
    }
}
