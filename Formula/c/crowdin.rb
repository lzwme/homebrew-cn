class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https:support.crowdin.comcli-tool"
  url "https:github.comcrowdincrowdin-clireleasesdownload4.7.1crowdin-cli.zip"
  sha256 "1a8d7fa33d0517c0618c00e48ea8df728417e704414bff59f66fffa41bd3273f"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c66fb3ec5cf9aae47a3655b43790a0201a13a842c884898b47fbdca36e705aaa"
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