class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://ghfast.top/https://github.com/morpheus65535/bazarr/releases/download/v1.5.5/bazarr.zip"
  sha256 "546dd85539e5833a4155bb9d4115f03c46950b816230e94740b2cf7436d1736b"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c97be0e0f392b5a83589a467c475f77923795fe1894b57b928eecdeb9cdcc60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aa8bf31dad4187d87838b288427b6df70a7797289a9f883aa5db65dfd8ea626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61a97e71460ade1bb6c53629a1b4781f205f04e6ae03ca82db03a2fd5e1e7bc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "adee9e6ac797bce7971f16a95e88d54e22e3e6efa1fd83ecf46e7531c2c2c07b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff317b08237413684034e68c1800c6eb5ae563c6a105f9e09d56fd0a887df5ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe26573b192f1438b1b0c02a5ed380db72f930014437317a191c68b18def0d88"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
  depends_on "unar"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  pypi_packages package_name:   "",
                extra_packages: ["lxml", "setuptools", "webrtcvad-wheels"]

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/76/95/faf61eb8363f26aa7e1d762267a8d602a1b26d4f3a1e758e92cb3cb8b054/setuptools-80.10.2.tar.gz"
    sha256 "8b0e9d10c784bf7d262c4e5ec5d4ec94127ce206e8738f29a437945fbc219b70"
  end

  resource "webrtcvad-wheels" do
    url "https://files.pythonhosted.org/packages/28/ba/3a8ce2cff3eee72a39ed190e5f9dac792da1526909c97a11589590b21739/webrtcvad_wheels-2.0.14.tar.gz"
    sha256 "5f59c8e291c6ef102d9f39532982fbf26a52ce2de6328382e2654b0960fea397"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources

    if build.head?
      # Build front-end.
      cd buildpath/"frontend" do
        system "npm", "install", *std_npm_args(prefix: false)
        system "npm", "run", "build"
      end
    end

    # Stop program from automatically downloading its own binaries.
    binaries_file = buildpath/"bazarr/utilities/binaries.json"
    binaries_file.unlink
    binaries_file.write "[]"

    # Prevent strange behavior of searching for a different python executable on macOS,
    # which won't have the required dependencies
    inreplace "bazarr.py", "def get_python_path():", "def get_python_path():\n    return sys.executable"

    libexec.install Dir["*"]
    (bin/"bazarr").write_env_script venv.root/"bin/python", "#{libexec}/bazarr.py",
      NO_UPDATE:  "1",
      PATH:       "#{Formula["ffmpeg"].opt_bin}:#{HOMEBREW_PREFIX}/bin:${PATH}",
      PYTHONPATH: venv.site_packages

    pkgvar = var/"bazarr"
    pkgvar.mkpath
    pkgvar.install_symlink pkgetc => "config"

    pkgetc.mkpath
    cp Dir[libexec/"data/config/*"], pkgetc

    libexec.install_symlink pkgvar => "data"

    (buildpath/"config.ini").write <<~INI
      [backup]
      folder = #{pkgvar}/backup
    INI
    pkgetc.install "config.ini"
  end

  service do
    run opt_bin/"bazarr"
    keep_alive true
    require_root true
    log_path var/"log/bazarr.log"
    error_log_path var/"log/bazarr.log"
  end

  test do
    require "open3"
    require "timeout"

    system bin/"bazarr", "--help"

    (testpath/"config/config.ini").write <<~INI
      [backup]
      folder = #{testpath}/custom_backup
    INI

    port = free_port

    Open3.popen3(bin/"bazarr", "--no-update", "--config", testpath, "--port", port.to_s) do |_, _, stderr, wait_thr|
      Timeout.timeout(45) do
        stderr.each do |line|
          refute_match "ERROR", line unless line.match? "Error trying to get releases from Github"
          break if line.include? "BAZARR is started and waiting for requests on: http://***.***.***.***:#{port}"
        end
        assert_match "<title>Bazarr</title>", shell_output("curl --silent http://localhost:#{port}")
      end
    ensure
      Process.kill "TERM", wait_thr.pid
    end

    assert_path_exists (testpath/"config/config.ini.old")
    assert_includes (testpath/"config/config.yaml").read, testpath/"custom_backup"
    assert_match "BAZARR is started and waiting for request", (testpath/"log/bazarr.log").read
  end
end