class JvmMon < Formula
  desc "Console-based JVM monitoring"
  homepage "https:github.comajermakovicsjvm-mon"
  url "https:github.comajermakovicsjvm-monarchiverefstags1.2.tar.gz"
  sha256 "5bc23aef365b9048fd4c4974028d4d1bbd79e495c9fa2d57446fc64a515d9319"
  license "Apache-2.0"
  head "https:github.comajermakovicsjvm-mon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10a26ecfa58c04851ac693f4078c151ba47bf479b960d85394cb72c899a28f9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09709070da8e62235d9ed766340d9d876e66bcc257f5d3c90ddde822645d278a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e4f4e6acf9d320c547226bd60956f2eff27f191112364c335cd7275ec74c45a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6395f1d02431f71ee3b99c0ab677c3ef7abbbbfe0791b18d633d1a413f64421d"
    sha256 cellar: :any_skip_relocation, ventura:       "d8adbf4d100d14d5f2b10d4c69e926ad9e4213a26c6f3c91eff6abb10c7bf73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8277320c0f5297ef19291fcc094805434559387bc24308597c3670d7b6abeeec"
  end

  depends_on "go" => :build
  depends_on "openjdk" => :build

  def install
    ENV["GOBIN"] = buildpath"bin"
    ENV.prepend_path "PATH", buildpath"bin"

    cd "jvm-mon-go" do
      system ".make-agent.sh"
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}jvm-mon -v 2>&1")

    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin"jvm-mon") do |_r, w, _pid|
      sleep 1
      w.write "q"
    end
  end
end