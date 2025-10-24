class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.38.4.tar.gz"
  sha256 "cb074ac7cbaaa25cddd97630ccb39c1fc101c3981f2a67d06d40116ffb92816d"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fb3373954a6302f8874c5c9c59d410b5ebbd12ec5816cf4e0d34d11b35a34c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0df97f5e3a1b4e04499b2e012e103cada972545fb3e7e1d91e5af0d956fc183a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52082fd1a6470330200db65a3f3ecb71e325189904713738ec1989d961ba027b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3f51385d229831b436d7238a0a3220be1d529715aec34774c17f6296e7c4aeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97675ab8198301bd7f053791f575bf4bc36aec462af06fa9c92385cfa1a9d066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c53ee2ad50284bb7cb85e4359689de09a8214af07bcd833a4bbbdc387753d5c"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end