Name:           tau-mock-configs
Version:        1.0
Release:        3%{?dist}
Summary:        tauOS mock configs

License:        MIT
URL:            https://tauos.co
Source0:        tau.tpl
Source5:        tau-1-x86_64.cfg
Source6:        tau-1-aarch64.cfg
BuildArch:      noarch

%description


%prep


%build


%install
mkdir -p %{buildroot}/etc/mock/templates
cp -v %{SOURCE0} %{buildroot}/etc/mock/templates
cp -v %{SOURCE5} %{buildroot}/etc/mock/
cp -v %{SOURCE6} %{buildroot}/etc/mock/


%files
/etc/mock/*
/etc/mock/templates/*



%changelog
* Fri Oct 07 2022 Cappy Ishihara <cappy@cappuchino.xyz>
- 
