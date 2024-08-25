class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https:support.crowdin.comcli-tool"
  url "https:github.comcrowdincrowdin-clireleasesdownload4.1.1crowdin-cli.zip"
  sha256 "129446127f9cb5e16de2d9fbd1bc9c22b2088e4f9950eda7e522b5e0773642ad"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "387268f108387a25943f9b5fe79e991deba63e372aa5c2a62e627613bf7a88b0"
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

    system bin"crowdin", "init"

    assert "Failed to collect project info",
      shell_output("#{bin}crowdin upload sources --config #{testpath}crowdin.yml 2>&1", 102)
  end
end