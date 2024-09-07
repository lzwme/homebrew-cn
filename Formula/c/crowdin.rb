class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https:support.crowdin.comcli-tool"
  url "https:github.comcrowdincrowdin-clireleasesdownload4.1.2crowdin-cli.zip"
  sha256 "0f4c31e7bd2953516eca843ad993cdd6ff630bdb51ac9bae41eb7c0fcc36bfe3"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a3bf3b09301002b1dc6e7026f4f4bf6b347bb19016e03b879f79e6548911f500"
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