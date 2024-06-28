class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https:github.comgooglebundletool"
  url "https:github.comgooglebundletoolreleasesdownload1.17.0bundletool-all-1.17.0.jar"
  sha256 "54ebee1f1de8367d9ad26b4672bfb2976b0b12142e15d683fc7b8e254fc6cc1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1281862a3031c91fc175843041b2db31e63300d765c646051de4d1312a91a7fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1281862a3031c91fc175843041b2db31e63300d765c646051de4d1312a91a7fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1281862a3031c91fc175843041b2db31e63300d765c646051de4d1312a91a7fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1281862a3031c91fc175843041b2db31e63300d765c646051de4d1312a91a7fb"
    sha256 cellar: :any_skip_relocation, ventura:        "1281862a3031c91fc175843041b2db31e63300d765c646051de4d1312a91a7fb"
    sha256 cellar: :any_skip_relocation, monterey:       "1281862a3031c91fc175843041b2db31e63300d765c646051de4d1312a91a7fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cd6d3bd56b23ed58c3c8db20bc1047981ab2844fdf3d979824d3aee23e413fa"
  end

  depends_on "openjdk"

  def install
    libexec.install "bundletool-all-#{version}.jar" => "bundletool-all.jar"
    bin.write_jar_script libexec"bundletool-all.jar", "bundletool"
  end

  test do
    resource "homebrew-test-bundle" do
      url "https:github.comthuongleitcrashlytics-samplerawmasterappreleaseapp.aab"
      sha256 "f7ea5a75ce10e394a547d0c46115b62a2f03380a18b1fc222e98928d1448775f"
    end

    resource("homebrew-test-bundle").stage do
      expected = <<~EOS
        App Bundle information
        ------------
        Feature modules:
        \tFeature module: base
        \t\tFile: resanimabc_fade_in.xml
      EOS

      assert_match expected, shell_output("#{bin}bundletool validate --bundle app.aab")
    end
  end
end