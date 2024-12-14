class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https:support.crowdin.comcli-tool"
  url "https:github.comcrowdincrowdin-clireleasesdownload4.5.0crowdin-cli.zip"
  sha256 "41cc35f77e4434c7eda2166bc2a45946b5e85d84e1a207c15cdcdfffa8c9c5a3"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "58ea2d4dd8093eab08d5a61fa22c05cb588731597592af098024a5723215f3ea"
  end

  depends_on "openjdk"

  def install
    libexec.install "crowdin-cli.jar"
    bin.write_jar_script libexec"crowdin-cli.jar", "crowdin"
  end

  test do
    (testpath"crowdin.yml").write <<~YAML
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
    YAML

    system bin"crowdin", "init"

    assert "Failed to collect project info",
      shell_output("#{bin}crowdin upload sources --config #{testpath}crowdin.yml 2>&1", 102)
  end
end