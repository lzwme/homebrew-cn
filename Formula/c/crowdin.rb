class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://ghfast.top/https://github.com/crowdin/crowdin-cli/archive/refs/tags/5.3.0.tar.gz"
  sha256 "5da284810e8b000bd0640ab9bca4bf5e8be6bd51b30fdf2449843e165bbe565d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "1a5d3e883742006eb9e08f7a8cd3665a13ea1d338fc3b3e449a2ed327362ec5f"
    sha256 arm64_tahoe:       "bcfd13028c26f6769db373d5b13ea4f88696653d1dc8aecc8aee3e68d9571c2f"
    sha256 arm64_sequoia:     "9856830456a19711430e6736e73054b308158367881a4196d9d12c570ccad651"
    sha256 arm64_linux:       "dda741e3345822f89531f713027f81bc538531363fcc6ef7bdb5a8638cae163d"
    sha256 x86_64_linux:      "ce855ec901b799f1145b78b22594a6a034bf4317ce62427ce38692a629d37933"
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