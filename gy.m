function [gy] = gy(xp,yp,zp,x1,x2,y1,y2,z1,z2,q)
%q为剩余密度,单位为g/cm3
%G为引力常量
%坐标P1(j1,k1,h1)与坐标P2(j2,k2,h2)代表长方体距离最远的对角点坐标
%r=((x-j).^2+(y-k).^2+(z-h).^2).^0.5
G=6.67e-11;
q1=q;%将剩余密度q的单位换算为kg/m3
%计算有限延深长方体重力异常
gy=0;
x(:,1)=xp-x1;
x(:,2)=xp-x2;
y(:,1)=yp-y1;
y(:,2)=yp-y2;
z(:,1)=zp-z1;
z(:,2)=zp-z2;
for s=1:2
    for d=1:2
        for f=1:2
            r=sqrt(x(:,s).*x(:,s)+y(:,d).*y(:,d)+z(:,f).*z(:,f));
            gy=(-1).^(s+d+f).*G.*q1.*((z(:,f).*safelog(x(:,s) + r) + x(:,s).*safelog(z(:,f) + r) ...
                - y(:,d).*atan(z(:,f).*x(:,s)./y(:,d)./r)))+gy;
            %             gy=(-1).^(s+d+f).*G.*q1.*((z(f)-zp).*log((x(s)-xp) + ((xp-x(s)).^2+(yp-y(d)).^2+(zp-z(f)).^2).^0.5) + (x(s)-xp).*log((z(f)-zp) + ((xp-x(s)).^2+(yp-y(d)).^2+(zp-z(f)).^2).^0.5) ...
            %                            - (y(d)-yp).*atan((z(f)-zp).*(x(s)-xp)./(y(d)-yp)./(((xp-x(s)).^2+(yp-y(d)).^2+(zp-z(f)).^2).^0.5)))+gy;
        end
    end
end
gy = fillmissing(gy,'previous');
end

