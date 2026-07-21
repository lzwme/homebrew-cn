class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "5769d2808c258e5a2fdb877c2eaa5996bba45c4003de53a8af5aa844dffcfed9"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "469140b3773f3e528c91e0d0c4bfa26541856a475394fd0290c518d42b8ce218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd440ce27289ef402993cc6baf5ff7e0d01f40d0d7a317c63076c57d855e51be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b57af613008b76160617420abf6520dc3c40031cccd84a60ac3fcbf606a34a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a23451ad3940a2673b342b3243755e00e86b8175dde297b67714ddc9fa99ac3"
    sha256 cellar: :any,                 arm64_linux:   "d3461c1eb09aeb69e5a8280d6501720b929bed2b0ef3d3c6f7486054a7299fbc"
    sha256 cellar: :any,                 x86_64_linux:  "9884a423ec2296ca89c627e79ee0594081626f518ed91727d6dcc3c067096839"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end