function [gxy] = gxy(xp,yp,zp,x1,x2,y1,y2,z1,z2,q)
%qΪʣ���ܶ�,��λΪg/cm3
%GΪ��������
%����P1(j1,k1,h1)������P2(j2,k2,h2)�������������Զ�ĶԽǵ�����
%r=((x-j).^2+(y-k).^2+(z-h).^2).^0.5
G=6.67e-11;
q1=q;%��ʣ���ܶ�q�ĵ�λ����Ϊkg/m3
%��������������������쳣
gxy=0;
x(:,1)=x1-xp;
x(:,2)=x2-xp;
y(:,1)=y1-yp;
y(:,2)=y2-yp;
z(:,1)=z1-zp;
z(:,2)=z2-zp;
for s=1:2
    for d=1:2
        for f=1:2
            r=sqrt(x(:,s).*x(:,s)+y(:,d).*y(:,d)+z(:,f).*z(:,f));
            gxy=(-1).^(s+d+f).*(-G.*q1.*log(z(:,f) + r))+gxy;
        end
    end
end
end
