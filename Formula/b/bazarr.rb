class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://ghfast.top/https://github.com/morpheus65535/bazarr/releases/download/v1.5.2/bazarr.zip"
  sha256 "63519d9855e5b84c947b18d72fa36dfa9341a040879d1079bfde2fabfe8ab30e"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "development"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18fc543c3b68a956d78c8cde0fc0c2d14cbe0f2651987b704cdf70f61f9fc84e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bf3862a5fe41abef772593e43d3214aac26ab085a22c9fa3a65efa36be588d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edd478bc8b93ebfe83efcc5ed3b664e61550bd170999ad28afcb64bee7f230cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8707f8a3f5e2f41252f6c5c5740e1018d8c91233e909853c6e2ac951e340f6be"
    sha256 cellar: :any_skip_relocation, ventura:       "6cc745bb28d2e5a7192db60bc2e28fc0a6b515a2b9fee31adecec4528c0f5902"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f81c0ded9e8eed480b6186bd813ec25703ff39f3e9903ad78b3e4f1861f7d62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e724662e022e172a0e14886c4019a6c095a0f744b4b22efc0fb5b9ca48b6afd"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "gcc"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "unar"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/95/32/0cc40fe41fd2adb80a2f388987f4f8db3c866c69e33e0b4c8b093fdf700e/setuptools-80.4.0.tar.gz"
    sha256 "5a78f61820bc088c8e4add52932ae6b8cf423da2aff268c23f813cfbb13b4006"
  end

  resource "webrtcvad-wheels" do
    url "https://files.pythonhosted.org/packages/28/ba/3a8ce2cff3eee72a39ed190e5f9dac792da1526909c97a11589590b21739/webrtcvad_wheels-2.0.14.tar.gz"
    sha256 "5f59c8e291c6ef102d9f39532982fbf26a52ce2de6328382e2654b0960fea397"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")
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
    (bin/"bazarr").write_env_script venv.root/"bin/python", libexec/"bazarr.py",
      NO_UPDATE:  "1",
      PATH:       "#{Formula["ffmpeg"].opt_bin}:#{HOMEBREW_PREFIX/"bin"}:$PATH",
      PYTHONPATH: venv.site_packages

    pkgvar = var/"bazarr"
    pkgvar.mkpath
    pkgvar.install_symlink pkgetc => "config"

    pkgetc.mkpath
    cp Dir[libexec/"data/config/*"], pkgetc

    libexec.install_symlink pkgvar => "data"
  end

  def post_install
    pkgvar = var/"bazarr"

    config_file = pkgetc/"config.ini"
    unless config_file.exist?
      config_file.write <<~INI
        [backup]
        folder = #{pkgvar}/backup
      INI
    end
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
          break if line.include? "BAZARR is started and waiting for requests on: http://0.0.0.0:#{port}"
        end
        assert_match "<title>Bazarr</title>", shell_output("curl --silent http://localhost:#{port}")
      end
    ensure
      Process.kill "TERM", wait_thr.pid
    end

    assert_path_exists (testpath/"config/config.ini.old")
    assert_includes (testpath/"config/config.yaml").read, "#{testpath}/custom_backup"
    assert_match "BAZARR is started and waiting for request", (testpath/"log/bazarr.log").read
  end
end