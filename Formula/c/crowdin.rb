class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://ghfast.top/https://github.com/crowdin/crowdin-cli/archive/refs/tags/5.1.0.tar.gz"
  sha256 "676c1c6e5246af89805caa7681f6f4ca62147250d30a71f446b49913231ee9bf"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "04eeacc885a0ed1749b2e478515221e190f0152c22e7275eeb34defcabe25375"
    sha256 arm64_tahoe:       "8d2625e8088d7eefcad1b394bbccadd33efe3b925108186b65cc4c2e27d616c7"
    sha256 arm64_sequoia:     "739824d4118b776a0aa5a491595319c6bbf64acb5257064f5e91ff7b7d74a6fa"
    sha256 arm64_linux:       "7c5a8ff2f6024ad9a89c563e11172249757cadc37dc1ef06fad9c6b25e0c2c4b"
    sha256 x86_64_linux:      "593b029dec7e6b49398596a312eef9a4d802d63473b2fe59196e682a6fbb9c3c"
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