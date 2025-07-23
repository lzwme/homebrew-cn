class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://ghfast.top/https://github.com/antonmedv/fx/archive/refs/tags/38.0.0.tar.gz"
  sha256 "b9c4b935852cb9c3bae39b1c1293a8bfb010c5d79ce71a1ea6197002a5291613"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e0696734b0012df06d5b7b62a8a3abfcc7ae5e6ffe746e714269adfec4cf998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e0696734b0012df06d5b7b62a8a3abfcc7ae5e6ffe746e714269adfec4cf998"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e0696734b0012df06d5b7b62a8a3abfcc7ae5e6ffe746e714269adfec4cf998"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3d5cce5cf8b548e599f765d7595b05696167847285c45d6872028345e36e2b2"
    sha256 cellar: :any_skip_relocation, ventura:       "c3d5cce5cf8b548e599f765d7595b05696167847285c45d6872028345e36e2b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a50578f55e250866a557a3ac77c5fa2925bb963513cedbf237c990262249b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end