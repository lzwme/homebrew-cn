class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "fb4373867fa7849d7b2789699ef09883c9a00979bad884fce96a9f8e05d872bf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd9f5e128b5b9e539f4105c4eda20f2a720fc733b73eff2692539b480dc1d880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0de071f6b4068fabccd7eaa6f98dc362591e9b63e19479fdc02ed05eb7f1a1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9d60eef9e9788c49228f76d1aac70ad4569b35e87f2d29d77a935552207152"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8687ffd4791255f92cafdcae7430b7ef025ef43105c674c0c90c04f5734c2f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94d126af34aa993a7f50b6124d3c025deb4fbd7c6f529c5357f880363755c19c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5a16c58829a1c87cd844f56b8f5d3c8b8f0780d59d0adf8dd266235f9766a78"
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
      system "cargo", "install", *std_cargo_args(path: "crates/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end