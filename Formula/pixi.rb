class Pixi < Formula
  desc "Package management made easy"
  homepage "https://github.com/prefix-dev/pixi"
  url "https://ghproxy.com/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "6b76294da2724604c308c60ca3a7a3654355157fa9df338cfd2b4e4b16fd2f96"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4f3304a341628289cebfd37b08e9fcfce5e2bb324359fd5dfaa9324728682fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ba983170ca108f86a6bfcbd31edd0a82dbbf90665ee1461a9fcf768ffe525aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db3fe6e7cbe96e5a6a8e854bbee6b1efbecad9092770926a41745fadbeebbba9"
    sha256 cellar: :any_skip_relocation, ventura:        "fea6630b2e66322a9b00a2c448249db2b1f45b66292949ee8c680ac65d60f127"
    sha256 cellar: :any_skip_relocation, monterey:       "91b56203302c6d6b79423da6b86e76c41c35d94d8d2cf8c77a25b0c0c5562f33"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6bb76ebc6af9311afba2e683ff1a7631005c4a035ddd0902fe0247e2bb567a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d83eb43c32fa314176ed221d31848bc952bfa6aa9ff0b8acb909195b17ad07b9"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip
    system "#{bin}/pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end