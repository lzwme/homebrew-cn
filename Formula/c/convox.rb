class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.24.7.tar.gz"
  sha256 "802eb8ffb086738eb86b151aa16019ba9036661c74f33c62da58e3b950176cf9"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27dfd5c3fa09a9a1c98cfeeb3671954d4cea0d38d2e1136cc21f64cbcb5b3054"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "915497f8ba3802136931d4f2126785f8998602a22902bced92f64cbcd21d285d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ec5b001dec6ffbeb412014ac3b8aa646132f61015dbe0287e9f558d8d2bbd15"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ee5fb5fe7898158f28a679d2bdcce2a4b7177f9c4d2acddd6f5b6fa785ed3ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e049870fbc014b681849de8c16e72400b816fb1f061b4095425a6001b7f7713f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a806d9d471316e9c6cc82e543f50d5022538d96840aef865ef5351cd571f0a"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end