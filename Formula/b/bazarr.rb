require "language/node"

class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://ghproxy.com/https://github.com/morpheus65535/bazarr/releases/download/v1.4.0/bazarr.zip"
  sha256 "b023f5239ec54974dfe624259942101ccad218d3b11bf47669a854dc3f31e56c"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b86bda28c2999fc7d2635e05feb2e3851433c97488655bcb44234246d382d2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "659b527ee019b664ac39f2ffca2937716ab4500254bfd3f011c1f866adddd4a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91de72f29d7dfaa19683efad12d8a6992a908a9e9725383c6bcd3dd2db2ca3d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e393d35bcdf1a74d205a4671dc6265b5529fd61741d1fcf8edaafc3489f868db"
    sha256 cellar: :any_skip_relocation, ventura:        "0919c7338b4793cbc4952a4cf7b6effa3df5268156094df1c4856fcbf9c5159c"
    sha256 cellar: :any_skip_relocation, monterey:       "c34850c84d0710712c569d21ab2bed635cf51e1958358cfd438345b4f04e23c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1a91a9d3660a49fc30ed3775e52c347798e4ff68723497a7efd92ae3fa164c"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "gcc"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python-lxml"
  depends_on "python@3.11"
  depends_on "unar"

  uses_from_macos "zlib"

  resource "webrtcvad-wheels" do
    url "https://files.pythonhosted.org/packages/59/d9/17fe64f981a2d33c6e95e115c29e8b6bd036c2a0f90323585f1af639d5fc/webrtcvad-wheels-2.0.11.post1.tar.gz"
    sha256 "aa1f749b5ea5ce209df9bdef7be9f4844007e630ac87ab9dbc25dda73fd5d2b7"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages("python3.11")
    venv = virtualenv_create(libexec, "python3.11")

    venv.pip_install resources

    if build.head?
      # Build front-end.
      cd buildpath/"frontend" do
        system "npm", "install", *Language::Node.local_npm_install_args
        system "npm", "run", "build"
      end
    end

    # Stop program from automatically downloading its own binaries.
    binaries_file = buildpath/"bazarr/utilities/binaries.json"
    rm binaries_file
    binaries_file.write "[]"

    libexec.install Dir["*"]
    (bin/"bazarr").write_env_script libexec/"bin/python", "#{libexec}/bazarr.py",
      NO_UPDATE:  "1",
      PATH:       "#{Formula["ffmpeg"].opt_bin}:#{HOMEBREW_PREFIX/"bin"}:$PATH",
      PYTHONPATH: ENV["PYTHONPATH"]

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
      config_file.write <<~EOS
        [backup]
        folder = #{pkgvar}/backup
      EOS
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

    system "#{bin}/bazarr", "--help"

    config_file = testpath/"config/config.ini"
    config_file.write <<~EOS
      [backup]
      folder = #{testpath}/custom_backup
    EOS

    port = free_port

    Open3.popen3("#{bin}/bazarr", "--no-update", "--config", testpath, "-p", port.to_s) do |_, _, stderr, wait_thr|
      Timeout.timeout(30) do
        stderr.each do |line|
          refute_match "ERROR", line unless line.match? "Error trying to get releases from Github"
          break if line.include? "BAZARR is started and waiting for request on http://0.0.0.0:#{port}"
        end
        assert_match "<title>Bazarr</title>", shell_output("curl --silent http://localhost:#{port}")
      end
    ensure
      Process.kill "TERM", wait_thr.pid
      Process.wait wait_thr.pid
    end

    assert_predicate (testpath/"config/config.ini.old"), :exist?
    new_config_file = testpath/"config/config.yaml"
    assert_includes File.read(new_config_file), "#{testpath}/custom_backup"
    bazarr_log = testpath/"log/bazarr.log"
    assert_match "BAZARR is started and waiting for request", bazarr_log.read
  end
end