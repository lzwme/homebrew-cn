class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://ghproxy.com/https://github.com/google/bundletool/releases/download/1.15.2/bundletool-all-1.15.2.jar"
  sha256 "96631521952ad064cc2554a8b40da51718ab00a673f30af01a491447d64ffdd0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15da3f3b650c17129d4b79e9b1e40298949a1109f23196f3011b2958102aea4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15da3f3b650c17129d4b79e9b1e40298949a1109f23196f3011b2958102aea4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15da3f3b650c17129d4b79e9b1e40298949a1109f23196f3011b2958102aea4d"
    sha256 cellar: :any_skip_relocation, ventura:        "15da3f3b650c17129d4b79e9b1e40298949a1109f23196f3011b2958102aea4d"
    sha256 cellar: :any_skip_relocation, monterey:       "15da3f3b650c17129d4b79e9b1e40298949a1109f23196f3011b2958102aea4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "15da3f3b650c17129d4b79e9b1e40298949a1109f23196f3011b2958102aea4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ce9c4c4ba0750d950b99a1c322bd8e0a244c1b6dcd3307b493574b2992ccfba"
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