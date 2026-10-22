class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://ghfast.top/https://github.com/crowdin/crowdin-cli/archive/refs/tags/5.5.0.tar.gz"
  sha256 "bfb363152db668267dd8a79239f9c698113d863e1777464af7cbccca90466185"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "414bbe3f57fbefefdeac6f18ec0b8b425fce844c2d60945e4be6db67117700fa"
    sha256 arm64_tahoe:       "7a1eb2a61a3b446895f0a8c78e76b7ad00e8338efcd00230473b718db3fc3e32"
    sha256 arm64_sequoia:     "6b4b8703880ff556fcc13e4f23fb61053f733ebc977dd73cb6bcaa4d68a75ee4"
    sha256 arm64_linux:       "6bb9f394831d4d0ecfc549d956476146af77f03c2c1bb99abbf30777c267a783"
    sha256 x86_64_linux:      "c83b2a472cc2566a7276624f10762db0f3e4654710f4aac4d117cd3b376653a9"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@78"
  end

  deny_network_access! :test

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
    (testpath/"locale/en.json").write <<~JSON
      {"greeting": "Hello"}
    JSON

    (testpath/"crowdin.yml").write <<~YAML
      "project_id": "12"
      "api_token": "54e01--your-personal-token--2724a"
      "base_path": "."
      "base_url": "https://api.crowdin.com" # https://{organization-name}.crowdin.com

      "preserve_hierarchy": true

      "files": [
        {
          "source" : "/locale/*.json",
          "translation" : "/%two_letters_code%/%original_file_name%"
        }
      ]
    YAML

    assert_match "Your configuration file looks good",
      shell_output("#{bin}/crowdin config lint --config #{testpath}/crowdin.yml")

    rm testpath/"locale/en.json"

    assert_match "No source files found for '/locale/*.json' pattern",
      shell_output("#{bin}/crowdin config lint --config #{testpath}/crowdin.yml 2>&1", 2)
  end
end