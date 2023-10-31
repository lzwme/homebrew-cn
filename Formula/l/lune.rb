class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://ghproxy.com/https://github.com/filiptibell/lune/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "ceb7832821a15d36bf5c2821f18dfa07d7d597b0699e2e3f9918115b8baa733b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ce52d0572501c8932b6ae51fdc6302559e11d9824cae32cbde2731ad4cc21c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "251035e9150e24fb56114c0c6b526e873dfc35b047b8492a97fc7758997d7017"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "211fba363b2b1ec9022d19e4270b03434072dfc53b832d470bbff93bb401d9d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "97c9e9c321230da519417a620eaf6165eeb126a22d22b0d28d3f1641113df720"
    sha256 cellar: :any_skip_relocation, ventura:        "f4e05e89dea830bf30119a24e379236cd7baf4a53062130412aae930fbd861f1"
    sha256 cellar: :any_skip_relocation, monterey:       "b432cec7ff281c93aa5fdca21dae03e7df2173bf6a4e46ab00fe6380fb708cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab5af448d820ad4a57fc58bd375a04e078e6024bc3746092a14ab785b5ecdddf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune test.lua").chomp
  end
end