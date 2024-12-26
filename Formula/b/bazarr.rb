class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https:www.bazarr.media"
  url "https:github.commorpheus65535bazarrreleasesdownloadv1.5.0bazarr.zip"
  sha256 "0b85e92622b8bd53ad0478b872a36c181bda0b28ab1d01a7d2473ddbfebba748"
  license "GPL-3.0-or-later"
  head "https:github.commorpheus65535bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9559d6bc327724d2d428f74775095e1385938a1d90a137b3a2cc1117ed291c20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b184133fa813befba2ac7ed45586a359d258ca391e3860339800aca7e2a7b643"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb3f2453f0cb0465ee847046b5e9cf5c4f4b70cd6684c77c0d5ce3a309dae5c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c15721d16593aef0c329ccfcdd0dcf83a05c4af7cc1ab04b5606c976b45b5219"
    sha256 cellar: :any_skip_relocation, ventura:       "9217c97bff3e434ab8a9096136ed0ce62f0aad89fdf808dd9ea9c05176ddad24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3908943effb00688a1b4ceb60a2f43f10cb127bb6afc19f959c8e426f74af442"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "gcc"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "unar"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4354292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "webrtcvad-wheels" do
    url "https:files.pythonhosted.orgpackages28ba3a8ce2cff3eee72a39ed190e5f9dac792da1526909c97a11589590b21739webrtcvad_wheels-2.0.14.tar.gz"
    sha256 "5f59c8e291c6ef102d9f39532982fbf26a52ce2de6328382e2654b0960fea397"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources

    if build.head?
      # Build front-end.
      cd buildpath"frontend" do
        system "npm", "install", *std_npm_args(prefix: false)
        system "npm", "run", "build"
      end
    end

    # Stop program from automatically downloading its own binaries.
    binaries_file = buildpath"bazarrutilitiesbinaries.json"
    binaries_file.unlink
    binaries_file.write "[]"

    # Prevent strange behavior of searching for a different python executable on macOS,
    # which won't have the required dependencies
    inreplace "bazarr.py", "def get_python_path():", "def get_python_path():\n    return sys.executable"

    libexec.install Dir["*"]
    (bin"bazarr").write_env_script venv.root"binpython", libexec"bazarr.py",
      NO_UPDATE:  "1",
      PATH:       "#{Formula["ffmpeg"].opt_bin}:#{HOMEBREW_PREFIX"bin"}:$PATH",
      PYTHONPATH: venv.site_packages

    pkgvar = var"bazarr"
    pkgvar.mkpath
    pkgvar.install_symlink pkgetc => "config"

    pkgetc.mkpath
    cp Dir[libexec"dataconfig*"], pkgetc

    libexec.install_symlink pkgvar => "data"
  end

  def post_install
    pkgvar = var"bazarr"

    config_file = pkgetc"config.ini"
    unless config_file.exist?
      config_file.write <<~INI
        [backup]
        folder = #{pkgvar}backup
      INI
    end
  end

  service do
    run opt_bin"bazarr"
    keep_alive true
    require_root true
    log_path var"logbazarr.log"
    error_log_path var"logbazarr.log"
  end

  test do
    require "open3"
    require "timeout"

    system bin"bazarr", "--help"

    (testpath"configconfig.ini").write <<~INI
      [backup]
      folder = #{testpath}custom_backup
    INI

    port = free_port

    Open3.popen3(bin"bazarr", "--no-update", "--config", testpath, "--port", port.to_s) do |_, _, stderr, wait_thr|
      Timeout.timeout(45) do
        stderr.each do |line|
          refute_match "ERROR", line unless line.match? "Error trying to get releases from Github"
          break if line.include? "BAZARR is started and waiting for requests on: http:0.0.0.0:#{port}"
        end
        assert_match "<title>Bazarr<title>", shell_output("curl --silent http:localhost:#{port}")
      end
    ensure
      Process.kill "TERM", wait_thr.pid
    end

    assert_predicate (testpath"configconfig.ini.old"), :exist?
    assert_includes (testpath"configconfig.yaml").read, "#{testpath}custom_backup"
    assert_match "BAZARR is started and waiting for request", (testpath"logbazarr.log").read
  end
end