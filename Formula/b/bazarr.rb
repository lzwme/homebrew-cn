class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://ghfast.top/https://github.com/morpheus65535/bazarr/releases/download/v1.6.2/bazarr.zip"
  sha256 "82d1c61ea8508b28503d820bd5924360cc503467e7de51fa29205cac34c2627b"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c73590e516700a7df2315970b883c84609c06d1f9f7bcda5e603cc927a1e164"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "45133d41ec3666290c28f4b5a5be3af04687449669710f2305a4a077554f8c01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b156e919db0efd65d93ec27bae6b458c60bd1211d941bee1f00717cdd16f99fa"
    sha256 cellar: :any,                 arm64_linux:       "eb0e2de8680a11f8c6c1f4b624302c6d6b9b956ae45d5b3b982597b9d703322f"
    sha256 cellar: :any,                 x86_64_linux:      "a715e89ef129a4459547b8ff791a784697037299b03510603d477c43e3953dbb"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
  depends_on "unar"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: ["lxml", "setuptools", "webrtcvad-wheels"]

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "webrtcvad-wheels" do
    url "https://files.pythonhosted.org/packages/28/ba/3a8ce2cff3eee72a39ed190e5f9dac792da1526909c97a11589590b21739/webrtcvad_wheels-2.0.14.tar.gz"
    sha256 "5f59c8e291c6ef102d9f39532982fbf26a52ce2de6328382e2654b0960fea397"
  end

  def install
    venv = virtualenv_create(libexec, python3)
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
      PATH:       "#{formula_opt_bin("ffmpeg")}:#{HOMEBREW_PREFIX}/bin:${PATH}",
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