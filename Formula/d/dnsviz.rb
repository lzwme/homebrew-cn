class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https:github.comdnsvizdnsviz"
  url "https:files.pythonhosted.orgpackages302657a692b8f913ae22450f5b1dde5c52fe9a262c3e678eb63a4bdc0e464781dnsviz-0.11.0.tar.gz"
  sha256 "3e93055950fc7837a40058f06190b0d9d7392332ea1aa0da6f9ff00c3b076d3e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "679f02dd6f5539efad854bd7a6b95c5614f2b2778bde100c2c2fa45c4a3cee12"
    sha256 cellar: :any,                 arm64_sonoma:  "3401d8a2860a252aa95ba065553a12f318363c5ae4a3799c53a9346d57f723ec"
    sha256 cellar: :any,                 arm64_ventura: "433ed13adb32db188bde5e54606270a2e4c50b1c537f679e427742d5d282eac5"
    sha256 cellar: :any,                 sonoma:        "bffdb76ff1a8b3fb1f23dcf1b4487e51393e5d806a702720ea42b90c2f67eb44"
    sha256 cellar: :any,                 ventura:       "c2490a66cb55a34bcdd34e6c35c7e651432aacfad5bd4ce4fa53acc7cb2e9315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b252d87ea09e3d8eb677fcf6d4bc78ee69f1845250522b17dd8f3ec7eff5890f"
  end

  depends_on "bind" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "json-c" => :test
  depends_on "cryptography"
  depends_on "graphviz"
  depends_on "openssl@3"
  depends_on "python@3.12"

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "pygraphviz" do
    url "https:files.pythonhosted.orgpackages8c417b9a22df38bb7884012b34f2986d765691dbe41bf5e7af881dfd09f8145fpygraphviz-1.13.tar.gz"
    sha256 "6ad8aa2f26768830a5a1cfc8a14f022d13df170a8f6fdfd68fd1aa1267000964"
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    resource "example-com-probe-auth" do
      url "https:raw.githubusercontent.comdnsvizdnsvizrefsheadsmastertestszonesunsignedexample.com-probe-auth.json"
      sha256 "6d75bf4e6289db41f8da6263aed2e0e8c910b8f303e4f065ec7d359997248997"
    end

    resource("example-com-probe-auth").stage do
      system bin"dnsviz", "probe", "-d", "0",
        "-r", "example.com-probe-auth.json",
        "-o", "example.com.json"
      system bin"dnsviz", "graph", "-r", "example.com.json", "-Thtml", "-o", "devnull"
      system bin"dnsviz", "grok", "-r", "example.com.json", "-o", "devnull"
      system bin"dnsviz", "print", "-r", "example.com.json", "-o", "devnull"
    end
  end
end