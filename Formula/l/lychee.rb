class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https:lychee.cli.rs"
  url "https:github.comlycheeverselycheearchiverefstagslychee-v0.19.0.tar.gz"
  sha256 "359ac354374f9ba93184d79f927274c44d22a35e834e4c6bfeec584720938cfc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comlycheeverselychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5de9c25c3b94fdb0f2229899ee5403f88f6293601f733eae2baf4230df271040"
    sha256 cellar: :any,                 arm64_sonoma:  "82b0d561aef5ecf91651cbf2e5a3186ca5e4bf7c8ee00e3eac62c327dcf76118"
    sha256 cellar: :any,                 arm64_ventura: "95af6b974a08e9fd11c8266c05fea941d28ac06cdf91849db2f00b08b3289658"
    sha256 cellar: :any,                 sonoma:        "5d12b139dc0aedd758a53743eafc35d2248eb76ba0ba6b4ced5efd7622ab7599"
    sha256 cellar: :any,                 ventura:       "9aa3f8e53d83addc09b4abd2f0feb3e0affc2ffb24fc2a28ea4741e5359d3faf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eccb57bbf09e609fae04e02a5bb94b468f76b2cec9c017740ec647a33443ec7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b54730bcbdc1f59213a921973887240c7d3a525bfb2e3ef52fae27e840fc832c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath"test.md").write "[This](https:example.com) is an example.\n"
    output = shell_output(bin"lychee #{testpath}test.md")
    assert_match "🔍 1 Total (in 0s) ✅ 0 OK 🚫 0 Errors 👻 1 Excluded", output
  end
end