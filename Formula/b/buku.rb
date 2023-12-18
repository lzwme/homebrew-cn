class Buku < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line bookmark manager"
  homepage "https:github.comjarunbuku"
  url "https:github.comjarunbukuarchiverefstagsv4.8.tar.gz"
  sha256 "a0b94210e80e9f9f359e5308323837d41781cf8dba497341099d5c59e27fa52c"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comjarunbuku.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "037f17e7dcc7dded30a95fa369818c1e36989caba338f992ae4177f012b32ff0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8501d6283d2411da8daced39212530523096284bf7b76df6af8b394ae6756bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68dbbad055d9c60edbbe6da48925e794a84704ac5d126a3434aa1d469bc5ab5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "571d030e2dfc682d8d6b3baf8d6e17b5678fce3ffb738cf5a340ca990ad82456"
    sha256 cellar: :any_skip_relocation, ventura:        "2f1fb3f88246ed3365cd1d11501dd377e903559f3c2c20de25c25cb164701799"
    sha256 cellar: :any_skip_relocation, monterey:       "7b88ae604d9346cbf223d8fe9bc97aabf80d32ac4ef4b489d55b1f6f16713e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f6951e795286f784f70eabee16ba12742c71c24dddeec2189c3b64c046aacf1"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-dateutil"
  depends_on "python-jinja"
  depends_on "python-markupsafe"
  depends_on "python-urllib3"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "expect" => :test
  uses_from_macos "libffi"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages7fc0c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "dominate" do
    url "https:files.pythonhosted.orgpackages80e4358a49a5567e38a12c56243f3a04642aebbbe4fe60e377e34d519f816c3edominate-2.9.0.tar.gz"
    sha256 "b15791ebea432218543a1702d76ae45d2ff95ff994e52014b8686a69dad772fd"
  end

  resource "Flask" do
    url "https:files.pythonhosted.orgpackages5f76a4d2c4436dda4b0a12c71e075c508ea7988a1066b06a575f6afe4fecc023Flask-2.2.5.tar.gz"
    sha256 "edee9b0a7ff26621bd5a8c10ff484ae28737a2410d99b0bb9a6850c7fb977aa0"
  end

  resource "Flask-Admin" do
    url "https:files.pythonhosted.orgpackagesbe4d7cad383a93e3e1dd9378f1fcf05ddc532c6d921fb30c19ce8f8583630f24Flask-Admin-1.6.1.tar.gz"
    sha256 "24cae2af832b6a611a01d7dc35f42d266c1d6c75a426b869d8cb241b78233369"
  end

  resource "Flask-API" do
    url "https:files.pythonhosted.orgpackagesdd4f49bd943d2ceeb2e5872a182b1547f7eadc53121e1ceea0f8718f1a97c4ccFlask-API-3.1.tar.gz"
    sha256 "cb079845f5573eac55c6800a9a142bd7b54fd1227019a21cb2f75dfe5311d44f"
  end

  resource "Flask-Bootstrap" do
    url "https:files.pythonhosted.orgpackages8853958ce7c2aa26280b7fd7f3eecbf13053f1302ee2acb1db58ef32e1c23c2aFlask-Bootstrap-3.3.7.1.tar.gz"
    sha256 "cb08ed940183f6343a64e465e83b3a3f13c53e1baabb8d72b5da4545ef123ac8"
  end

  resource "flask-paginate" do
    url "https:files.pythonhosted.orgpackages6a2c79a20c141c58f0993f3e40e280376618800e3cd5a503cacf7db84e4785dcflask-paginate-2022.1.8.tar.gz"
    sha256 "a32996ec07ca004c45b768b0d50829728ab8f3986c0650ef538e42852c7aeba2"
  end

  resource "Flask-WTF" do
    url "https:files.pythonhosted.orgpackages80555114035eb8f6200fbe838a4b9828409ac831408c4591bf7875aed299d5f8Flask-WTF-1.1.1.tar.gz"
    sha256 "41c4244e9ae626d63bed42ae4785b90667b885b1535d5a4095e1f63060d12aa9"
  end

  resource "html5lib" do
    url "https:files.pythonhosted.orgpackagesacb6b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages7fa1d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackages479e780779233a615777fbdf75a4dee2af7a345f4bf74b42d4a5f836800b9d91soupsieve-2.4.1.tar.gz"
    sha256 "89d12b2d5dfcd2c9e8c22326da9d9aa9cb3dfab0a83a024f05704076ee8d35ea"
  end

  resource "visitor" do
    url "https:files.pythonhosted.orgpackagesd758785fcd6de4210049da5fafe62301b197f044f3835393594be368547142b0visitor-0.1.3.tar.gz"
    sha256 "2c737903b2b6864ebc6167eef7cf3b997126f1aa94bdf590f90f1436d23e480a"
  end

  resource "webencodings" do
    url "https:files.pythonhosted.orgpackages0b02ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "Werkzeug" do
    url "https:files.pythonhosted.orgpackagesd17ec35cea5749237d40effc50ed1a1c7518d9f2e768fcf30b4e9ea119e74975Werkzeug-2.3.6.tar.gz"
    sha256 "98c774df2f91b05550078891dee5f0eb0cb797a522c757a2452b9cee5b202330"
  end

  resource "WTForms" do
    url "https:files.pythonhosted.orgpackages9a7dd4aa68f5bfcb91dd61a7faf0e862512ae7b3d531c41f24c217910aec0559WTForms-3.0.1.tar.gz"
    sha256 "6b351bbb12dd58af57ffef05bc78425d08d1914e0fd68ee14143b7ade023c5bc"
  end

  def install
    virtualenv_install_with_resources
    man1.install "buku.1"
    bash_completion.install "auto-completionbashbuku-completion.bash" => "buku"
    fish_completion.install "auto-completionfishbuku.fish"
    zsh_completion.install "auto-completionzsh_buku"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["XDG_DATA_HOME"] = "#{testpath}.localshare"

    # Firefox exported bookmarks file
    (testpath"bookmarks.html").write <<~EOS
      <!DOCTYPE NETSCAPE-Bookmark-file-1>
      <META HTTP-EQUIV="Content-Type" CONTENT="texthtml; charset=UTF-8">
      <TITLE>Bookmarks<TITLE>
      <H1>Bookmarks Menu<H1>

      <DL><p>
          <HR>    <DT><H3 ADD_DATE="1464091987" LAST_MODIFIED="1477369518" PERSONAL_TOOLBAR_FOLDER="true">Bookmarks Toolbar<H3>
          <DD>Add bookmarks to this folder to see them displayed on the Bookmarks Toolbar
          <DL><p>
              <DT><A HREF="https:github.comHomebrewbrew" ADD_DATE="1477369518" LAST_MODIFIED="1477369529">Title unknown<A>
          <DL><p>
      <DL>
    EOS

    system bin"buku", "--nostdin", "--nc", "--tacit", "--import", "bookmarks.html"
    assert_equal <<~EOS, shell_output("#{bin}buku --nostdin --nc --print").chomp
      1. Title unknown
         > https:github.comHomebrewbrew
         # bookmarks toolbar
    EOS

    # Test online components -- fetch titles
    assert_match "Index 1: updated", shell_output("#{bin}buku --nostdin --nc --update")

    # Test crypto functionality
    (testpath"crypto-test").write <<~EOS
      # Lock bookmark database
      spawn #{bin}buku --lock
      expect "Password: "
      send "password\r"
      expect "Password: "
      send "password\r"
      expect {
          -re ".*ERROR.*" { exit 1 }
          "File encrypted"
      }

      # Unlock bookmark database
      spawn #{bin}buku --unlock
      expect "Password: "
      send "password\r"
      expect {
          -re ".*ERROR.*" { exit 1 }
          "File decrypted"
      }
    EOS
    system "expect", "-f", "crypto-test"

    # Test database content and search
    result = shell_output("#{bin}buku --np --sany Homebrew")
    assert_match "https:github.comHomebrewbrew", result
    assert_match "The missing package manager for macOS", result

    # Test bukuserver
    result = shell_output("#{bin}bukuserver --version")
    assert_match version.to_s, result

    port = free_port
    pid = fork do
      $stdout.reopen("devnull")
      $stderr.reopen("devnull")
      exec "#{bin}bukuserver", "run", "--host", "127.0.0.1", "--port", port.to_s
    end

    begin
      sleep 10
      result = shell_output("curl -s 127.0.0.1:#{port}apibookmarks")
      assert_match "https:github.comHomebrewbrew", result
      assert_match "The missing package manager for macOS", result
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end