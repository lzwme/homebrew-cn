class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://ghfast.top/https://github.com/crowdin/crowdin-cli/releases/download/4.10.0/crowdin-cli.zip"
  sha256 "c6f0c5f6fa6d9065e43d21e7b4facd5f4678a58992e81bb88c4b304e4ff8ba11"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f99ac85287aa7281f336aabeb393a0fe44c8ad1b80f7146600da0e53fe323313"
  end

  depends_on "openjdk"

  def install
    libexec.install "crowdin-cli.jar"
    bin.write_jar_script libexec/"crowdin-cli.jar", "crowdin"
  end

  test do
    (testpath/"crowdin.yml").write <<~YAML
      "project_id": "12"
      "api_token": "54e01--your-personal-token--2724a"
      "base_path": "."
      "base_url": "https://api.crowdin.com" # https://{organization-name}.crowdin.com

      "preserve_hierarchy": true

      "files": [
        {
          "source" : "/t1/**/*",
          "translation" : "/%two_letters_code%/%original_file_name%"
        }
      ]
    YAML

    system bin/"crowdin", "init"

    assert "Failed to collect project info",
      shell_output("#{bin}/crowdin upload sources --config #{testpath}/crowdin.yml 2>&1", 102)
  end
end