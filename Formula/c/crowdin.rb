class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://ghfast.top/https://github.com/crowdin/crowdin-cli/archive/refs/tags/5.0.0.tar.gz"
  sha256 "e7489414d2da9fdb4b0aab6b90479c5cea672fbf515221e9fc24124feef3dedc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b7a4fae2d5118110a182e319e270759b93ae860a5d46405a672d81467d118652"
    sha256 arm64_sequoia: "4f52f1c6e54310dbdf796f5d5b6cedb42516ab2e29dec31b2ed9c399fffa4ca7"
    sha256 arm64_sonoma:  "8588d1a064fc6133ad01cd82c70cf57fa04abe82f26038a085173713decfd94c"
    sha256 arm64_linux:   "eecd405fe13ab4e0796adecdfd778ac0fa79dbfb0af94627ef00554c73c39d00"
    sha256 x86_64_linux:  "e571718c5554642c6e95f8fa6a8b14ff8b80e8841815dc7494ebf13bacf219bb"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@78"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula
      icu = deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    system "bun", "run", "build"

    bin.install "dist/crowdin"
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

    assert "Failed to collect project info",
      shell_output("#{bin}/crowdin upload sources --config #{testpath}/crowdin.yml 2>&1", 102)
  end
end