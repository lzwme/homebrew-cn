class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https:support.crowdin.comcli-tool"
  url "https:github.comcrowdincrowdin-clireleasesdownload4.1.0crowdin-cli.zip"
  sha256 "5e69f2cf8f15f4c99efa44899f1f34316390d879b2ec2d0809e4ee8e6d31c746"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ade82f03827f5d2f1db1a9cd44c7cbdf0244bc4c5d8b08b224c16ae5b57dccaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ade82f03827f5d2f1db1a9cd44c7cbdf0244bc4c5d8b08b224c16ae5b57dccaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ade82f03827f5d2f1db1a9cd44c7cbdf0244bc4c5d8b08b224c16ae5b57dccaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "83e56efb4d6fe564b4f66ae1abf33f2db9b193e13dcc5ab3335ee363db0a0e66"
    sha256 cellar: :any_skip_relocation, ventura:        "ee200c74bc878770ec16d8defe2ba40c1538a9f387f6fd9cc94ef0b37c176525"
    sha256 cellar: :any_skip_relocation, monterey:       "ade82f03827f5d2f1db1a9cd44c7cbdf0244bc4c5d8b08b224c16ae5b57dccaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8de2fc505dad2e5a64661f32d717a5a565ba5cedeca5de4a89cc3fdf1a8517ef"
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