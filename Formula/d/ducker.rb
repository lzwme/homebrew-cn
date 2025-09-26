class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://ghfast.top/https://github.com/robertpsoane/ducker/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "e38bbf273d01300f4213d46d7a831c8ebf64dfb65bc91ff128694385a51f11d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ca9c2329b89a1d8af635a1b1863c60f818b497e1f41064118288a8b12e573df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a8fb2799c25bc6ad1952220029146e3d111ad6ab89a9734fa890ad3a7f70ab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df92f6dd2b8fd1fb9d01bc8cb047167ced939ebebd3701f331bebc9fecdbf8d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c0858bbb06426d91371dc3ea472a517cff535d8ff8151aeed4ea8dd9c8cfee8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5859e3c7235852fdd7549054b49aec8ab8d8b182c2a685a93f22dc2eb0eb2f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2186bda440f430c4eb012dc8363ba81b33bffcee649c83747f4f7b09d1249d5b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end