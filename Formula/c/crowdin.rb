class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https:support.crowdin.comcli-tool"
  url "https:github.comcrowdincrowdin-clireleasesdownload3.19.4crowdin-cli.zip"
  sha256 "483e03f705be4ddaf7983f754892a6e4ade092d1f4cb0401461d1dd5331e2c3b"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2cf69c951481dd1f1db07639c254ae78d2bcd73ade44a0d71aff6473d1bfc60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eea912906c259172a64d8abbcec6832120ab53f120b5206e1892c258a0bfaf63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41a5a32e59589f420c2643f4f9dba8541756d33af6fd7e6431ac97640016603"
    sha256 cellar: :any_skip_relocation, sonoma:         "535641e3c0b4bf61ca023c8e776990b96f256a0601df28a7b593dbb3d55c6023"
    sha256 cellar: :any_skip_relocation, ventura:        "8724c9a7decdc49d2182bb3f79e97a28bd663f3a39c5681cf32cc35bc4558bbf"
    sha256 cellar: :any_skip_relocation, monterey:       "52f73b3cc145c9b5cc7a306e7df2bad072f44d25a0caf254c36af2505e8e46a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5527a4a286180264fef80691c860a9cb745d91316635808418af0083558b0e2"
  end

  depends_on "openjdk"

  def install
    libexec.install "crowdin-cli.jar"
    bin.write_jar_script libexec"crowdin-cli.jar", "crowdin"
  end

  test do
    (testpath"crowdin.yml").write <<~EOS
      "project_id": "12"
      "api_token": "54e01--your-personal-token--2724a"
      "base_path": "."
      "base_url": "https:api.crowdin.com" # https:{organization-name}.crowdin.com

      "preserve_hierarchy": true

      "files": [
        {
          "source" : "t1***",
          "translation" : "%two_letters_code%%original_file_name%"
        }
      ]
    EOS

    assert "Your configuration file looks good",
      shell_output("#{bin}crowdin lint")

    assert "Failed to authorize in Crowdin",
      shell_output("#{bin}crowdin upload sources --config #{testpath}crowdin.yml", 1)
  end
end