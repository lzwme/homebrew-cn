class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https:support.crowdin.comcli-tool"
  url "https:github.comcrowdincrowdin-clireleasesdownload3.19.2crowdin-cli.zip"
  sha256 "b557dda7243f9ba669540ed81669064a7a68f3f162ac8044888a87954af54ca9"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4604dc38e61f0fc515e6c401249ac1ae235e8dbebcbcd728e548dcaa3d8629e"
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