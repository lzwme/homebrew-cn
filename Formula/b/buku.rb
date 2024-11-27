class Buku < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line bookmark manager"
  homepage "https:github.comjarunbuku"
  url "https:github.comjarunbukuarchiverefstagsv4.9.tar.gz"
  sha256 "1e432270ae78c7852110dcf2c2e215893bcc338299a4998f14a1f6b26e37bfac"
  license "GPL-3.0-or-later"
  revision 3
  head "https:github.comjarunbuku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91c197ca9aa2c9dab0f7dc7fca83d9ec957c08f936791c7ea9baa5baaac053b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8373d4f30efef28097c4836a6ca12076eb7c700b8c5a881ac1963ec276efeebf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05c8754f49764e3a858755539096b8ef41494586237754b9eebd1ec5afb5ac87"
    sha256 cellar: :any_skip_relocation, sonoma:        "769a6a9b5fd71a38805879af37f9b8af4be10497f37e3adcf61e9db8695e805d"
    sha256 cellar: :any_skip_relocation, ventura:       "d6628b26bfb355c40b1dd83db291d3e65094f6fd9d28221df1f7cffe593f9e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7677e9fc2fef63e82ca4e269e58b5e3301aecca9a9c01b0712deb7790b33ad7"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "expect" => :test
  uses_from_macos "libffi"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "dominate" do
    url "https:files.pythonhosted.orgpackagesfbf31c8088ff19a0fcd9c3234802a0ee47006ea64bd8852f1019194f0e3583ffdominate-2.9.1.tar.gz"
    sha256 "558284687d9b8aae1904e3d6051ad132dd4a8c0cf551b37ea4e7e42a31d19dc4"
  end

  resource "flask" do
    url "https:files.pythonhosted.orgpackages5f76a4d2c4436dda4b0a12c71e075c508ea7988a1066b06a575f6afe4fecc023Flask-2.2.5.tar.gz"
    sha256 "edee9b0a7ff26621bd5a8c10ff484ae28737a2410d99b0bb9a6850c7fb977aa0"
  end

  resource "flask-admin" do
    url "https:files.pythonhosted.orgpackagesbe4d7cad383a93e3e1dd9378f1fcf05ddc532c6d921fb30c19ce8f8583630f24Flask-Admin-1.6.1.tar.gz"
    sha256 "24cae2af832b6a611a01d7dc35f42d266c1d6c75a426b869d8cb241b78233369"
  end

  resource "flask-api" do
    url "https:files.pythonhosted.orgpackagesdd4f49bd943d2ceeb2e5872a182b1547f7eadc53121e1ceea0f8718f1a97c4ccFlask-API-3.1.tar.gz"
    sha256 "cb079845f5573eac55c6800a9a142bd7b54fd1227019a21cb2f75dfe5311d44f"
  end

  resource "flask-bootstrap" do
    url "https:files.pythonhosted.orgpackages8853958ce7c2aa26280b7fd7f3eecbf13053f1302ee2acb1db58ef32e1c23c2aFlask-Bootstrap-3.3.7.1.tar.gz"
    sha256 "cb08ed940183f6343a64e465e83b3a3f13c53e1baabb8d72b5da4545ef123ac8"
  end

  resource "flask-paginate" do
    url "https:files.pythonhosted.orgpackages5cd0aca9153b109f0062eaadb497448f5e596f87cc89474d77347a1d931c8842flask-paginate-2024.4.12.tar.gz"
    sha256 "2de04606b061736f0fc8fbe73d9d4d6fc03664638eca70a57728b03b3e2c9577"
  end

  resource "flask-wtf" do
    url "https:files.pythonhosted.orgpackages9befb6ec35e02f479f6e76e02ede14594c9cfa5e6dcbab6ea0e82fa413993a2aflask_wtf-1.2.1.tar.gz"
    sha256 "8bb269eb9bb46b87e7c8233d7e7debdf1f8b74bf90cc1789988c29b37a97b695"
  end

  resource "html5lib" do
    url "https:files.pythonhosted.orgpackagesacb6b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages9ccb8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31ditsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages61c5c3a4d72ffa8efc2e78f7897b1c69ec760553246b67d3ce8c4431fac5d4e3types-python-dateutil-2.9.0.20240316.tar.gz"
    sha256 "5d2f2e240b86905e40944dd787db6da9263f0deabef1076ddaed797351ec0202"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesc89365e479b023bbc46dab3e092bda6b0005424ea3217d711964ccdede3f9b1burllib3-1.26.19.tar.gz"
    sha256 "3e3d753a8618b86d7de333b4223005f68720bcd6a7d2bcb9fbd2229ec7c1e429"
  end

  resource "visitor" do
    url "https:files.pythonhosted.orgpackagesd758785fcd6de4210049da5fafe62301b197f044f3835393594be368547142b0visitor-0.1.3.tar.gz"
    sha256 "2c737903b2b6864ebc6167eef7cf3b997126f1aa94bdf590f90f1436d23e480a"
  end

  resource "webencodings" do
    url "https:files.pythonhosted.orgpackages0b02ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages3d4bd746f1000782c89d6c97df9df43ba8f4d126038608843d3560ae88d201b5werkzeug-2.3.8.tar.gz"
    sha256 "554b257c74bbeb7a0d254160a4f8ffe185243f52a52035060b761ca62d977f03"
  end

  resource "wtforms" do
    url "https:files.pythonhosted.orgpackages6ac796d10183c3470f1836846f7b9527d6cb0b6c2226ebca40f36fa29f23de60wtforms-3.1.2.tar.gz"
    sha256 "f8d76180d7239c94c6322f7990ae1216dae3659b7aa1cee94b6318bdffb474b9"
  end

  # fixed url value passed to update_rec() from CLI
  # upstream PR fix, https:github.comjarunbukupull730
  patch do
    url "https:github.comjarunbukucommit957f9b850f9c7c3da33a50cd76db7b1dd16a4c17.patch?full_index=1"
    sha256 "01325da9a4d4d9367d864b7aaad3f01cf1cf76bf196653201bcf0b776b51e60a"
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
    (testpath"bookmarks.html").write <<~HTML
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
    HTML

    system bin"buku", "--nostdin", "--nc", "--tacit", "--import", "bookmarks.html"
    assert_equal <<~EOS, shell_output("#{bin}buku --nostdin --nc --print").chomp
      1. Title unknown
         > https:github.comHomebrewbrew
         # bookmarks toolbar
    EOS

    # Test online components -- fetch titles
    assert_match "Index 1: updated", shell_output("#{bin}buku --nostdin --nc --update")

    # Test crypto functionality
    (testpath"crypto-test").write <<~SHELL
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
    SHELL
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
      $stdout.reopen(File::NULL)
      $stderr.reopen(File::NULL)
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