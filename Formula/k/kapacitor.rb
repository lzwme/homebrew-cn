class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https:github.cominfluxdatakapacitor"
  license "MIT"
  head "https:github.cominfluxdatakapacitor.git", branch: "master"

  stable do
    url "https:github.cominfluxdatakapacitor.git",
        tag:      "v1.7.3",
        revision: "43be9330273f227c6b5495a97019483577c542a7"

    # build patch to upgrade flux so that it can be built with rust 1.72.0+
    # upstream PR ref, https:github.cominfluxdatakapacitorpull2811
    patch do
      url "https:github.cominfluxdatakapacitorcommit1bc086f38b5164813c0f5b0989045bd21d543377.patch?full_index=1"
      sha256 "38ab4f97dfed87cde492c0f1de372dc6563bcdda10741cace7a99f8d3ab777b6"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad8297a4ea43e8828f469d2f6b7ce51e3cdd400c433bb0704d956f785c8edf60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "342e715c78a0d7e7d561f1f007b1e0c5953059d1c1a0217348a3a6509c8b410c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98cb7ab8d8b7d46f1bf4be85a0777ce062b1c3172ae1b0b643654908c08972d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "695d66d7615886b75bb3ffdfe6793c606a6d1536f8bcc9fca8367bcec8f3ef76"
    sha256 cellar: :any_skip_relocation, ventura:        "bbb3b1795df03094af6882ff6bc626c69f7d45f7ddcc2e74302d85cc2b9a8d7e"
    sha256 cellar: :any_skip_relocation, monterey:       "42eceee9e2fd334fd15d3ea2d07f6e45c5e9d7e04e1913a8fe2e3d4cff53373b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4531514860c13fcd4ff0b047d867e3730d14554de778b951a0aad875bcd8d1f2"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build # for `pkg-config-wrapper`
  end

  # NOTE: The version here is specified in the go.mod of kapacitor.
  # If you're upgrading to a newer kapacitor version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https:github.cominfluxdatapkg-configarchiverefstagsv0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"
  end

  def install
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath"bootstrappkg-config"
    end
    ENV.prepend_path "PATH", buildpath"bootstrap"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), ".cmdkapacitor"
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "-o", bin"kapacitord", ".cmdkapacitord"

    inreplace "etckapacitorkapacitor.conf" do |s|
      s.gsub! "varlibkapacitor", "#{var}kapacitor"
      s.gsub! "varlogkapacitor", "#{var}log"
    end

    etc.install "etckapacitorkapacitor.conf" => "kapacitor.conf"
  end

  def post_install
    (var"kapacitorreplay").mkpath
    (var"kapacitortasks").mkpath
  end

  service do
    run [opt_bin"kapacitord", "-config", etc"kapacitor.conf"]
    keep_alive successful_exit: false
    error_log_path var"logkapacitor.log"
    log_path var"logkapacitor.log"
    working_dir var
  end

  test do
    (testpath"config.toml").write shell_output("#{bin}kapacitord config")

    inreplace testpath"config.toml" do |s|
      s.gsub! "disable-subscriptions = false", "disable-subscriptions = true"
      s.gsub! %r{data_dir = ".*.kapacitor"}, "data_dir = \"#{testpath}kapacitor\""
      s.gsub! %r{.*.kapacitorreplay}, "#{testpath}kapacitorreplay"
      s.gsub! %r{.*.kapacitortasks}, "#{testpath}kapacitortasks"
      s.gsub! %r{.*.kapacitorkapacitor.db}, "#{testpath}kapacitorkapacitor.db"
    end

    http_port = free_port
    ENV["KAPACITOR_URL"] = "http:localhost:#{http_port}"
    ENV["KAPACITOR_HTTP_BIND_ADDRESS"] = ":#{http_port}"
    ENV["KAPACITOR_INFLUXDB_0_ENABLED"] = "false"
    ENV["KAPACITOR_REPORTING_ENABLED"] = "false"

    begin
      pid = fork do
        exec "#{bin}kapacitord -config #{testpath}config.toml"
      end
      sleep 20
      shell_output("#{bin}kapacitor list tasks")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end