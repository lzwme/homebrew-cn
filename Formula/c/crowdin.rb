class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://ghfast.top/https://github.com/crowdin/crowdin-cli/archive/refs/tags/5.0.1.tar.gz"
  sha256 "b630cce96fa1670917a7b5dc9c3a46c3f7834a420aebd9fc9de238a62f6b3b44"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8b4aea1601d56a5e3d571d932946c390d9b2d61b645a2de3042bbe7acceb4626"
    sha256 arm64_sequoia: "c705c27a8c6d6b04f4b394bd0d5de9fd1d17b8c400dbb0806d3feacb35ac2b0a"
    sha256 arm64_sonoma:  "2c790a371aa188d2fbae4675deb5ca8caf5500e9b6f1c2020d9f67491c3b17f4"
    sha256 arm64_linux:   "1896f3ee14a8647f65dd0c2a079c8131081b381fe399f85b87f0405247dde9f8"
    sha256 x86_64_linux:  "a2f4f0c4625cfa70f3cc5ffa9a84819fb11b4f5b4b5a2a95e6be9219d2b29117"
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