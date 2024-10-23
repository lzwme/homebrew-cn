class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https:github.comgooglebundletool"
  url "https:github.comgooglebundletoolreleasesdownload1.17.2bundletool-all-1.17.2.jar"
  sha256 "2d4ad908faea64047c1cc9cb747e6aa667c6ab192e09607bd16b67246a8cd6ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cfc21842e258d541892f52e00161b2da8dededd755354e3066e91bbff4d65f8"
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