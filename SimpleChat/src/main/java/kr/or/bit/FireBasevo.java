package kr.or.bit;

public class FireBasevo {

    String id;

    String name;

    int age;

    String tel;

 

    @Override

    public String toString() {

        return "BtsVideoVO [id=" + id + ", name=" + name + ", age=" + age + ", tel=" + tel + "]";

    }

    public String getId() {

        return id;

    }

    public void setId(String id) {

        this.id = id;

    }

    public String getName() {

        return name;

    }

    public void setName(String name) {

        this.name = name;

    }

    public int getAge() {

        return age;

    }

    public void setAge(int age) {

        this.age = age;

    }

    public String getTel() {

        return tel;

    }

    public void setTel(String tel) {

        this.tel = tel;

    }

 

}
