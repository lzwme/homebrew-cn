class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://ghproxy.com/https://github.com/google/bundletool/releases/download/1.15.0/bundletool-all-1.15.0.jar"
  sha256 "14e7b268e175c1a832d1695a1cf46c5c7e06949093e6efb7a83c64d7a252f7f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1833145a45256ec6fee17c57acc8ff46ad2f7164a8af5b9c33f92e45a0999b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1833145a45256ec6fee17c57acc8ff46ad2f7164a8af5b9c33f92e45a0999b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1833145a45256ec6fee17c57acc8ff46ad2f7164a8af5b9c33f92e45a0999b6"
    sha256 cellar: :any_skip_relocation, ventura:        "e1833145a45256ec6fee17c57acc8ff46ad2f7164a8af5b9c33f92e45a0999b6"
    sha256 cellar: :any_skip_relocation, monterey:       "e1833145a45256ec6fee17c57acc8ff46ad2f7164a8af5b9c33f92e45a0999b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1833145a45256ec6fee17c57acc8ff46ad2f7164a8af5b9c33f92e45a0999b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e82dccd51eff3e8929fa6b17d8b94e415d029392ea4be0e3275ff108b8f62b7"
  end

  depends_on "openjdk"

  resource "homebrew-test-bundle" do
    url "https://github.com/thuongleit/crashlytics-sample/raw/master/app/release/app.aab"
    sha256 "f7ea5a75ce10e394a547d0c46115b62a2f03380a18b1fc222e98928d1448775f"
  end

  def install
    libexec.install "bundletool-all-#{version}.jar" => "bundletool-all.jar"
    bin.write_jar_script libexec/"bundletool-all.jar", "bundletool"
  end

  test do
    resource("homebrew-test-bundle").stage do
      expected = <<~EOS
        App Bundle information
        ------------
        Feature modules:
        \tFeature module: base
        \t\tFile: res/anim/abc_fade_in.xml
      EOS

      assert_match expected, shell_output("#{bin}/bundletool validate --bundle app.aab")
    end
  end
end