class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://ghfast.top/https://github.com/anomalyco/opencode/archive/refs/tags/v1.18.25.tar.gz"
  sha256 "44e9530d7be172005c7d60aef317440eecb85d557d94cce7fa35c5a7b9d9da0b"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "cc2ed06c5243b678e0822598ead33442327a967206b7a73ab6d9d30fdbb4b6b9"
    sha256 arm64_sequoia: "f28fb304d187f075ef64a9aaed99cb4900699199defe1a69e113070228423134"
    sha256 arm64_sonoma:  "32feab0437965d38c73a2717c9be2abe31d8039eb03335246d384c71f6c7079e"
    sha256 arm64_linux:   "93885a6f47b79fa58ef575d60e30b5677467b87fd4d2ada6373815ffed3c21a3"
    sha256 x86_64_linux:  "6fd7d0b5885503a4a3c220846cccc22ea4ca0c78b739068ebf40c208d7903223"
  end

  depends_on "bun" => :build
  depends_on "python@3.14" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "icu4c@78"
  end

  deny_network_access! :test

  def install
    ENV["OPENCODE_VERSION"] = version.to_s
    ENV["OPENCODE_CHANNEL"] = "prod"

    system "bun", "install", "--frozen-lockfile"

    cd "packages/opencode" do
      system "bun", "--bun", "./script/build.ts", "--single", "--skip-install"
      bin.install Pathname.pwd.glob("dist/opencode-*/bin/opencode").first
    end

    generate_completions_from_executable(bin/"opencode", "completion", shell_parameter_format: :none, shells: [:zsh])
  end

  test do
    ENV["OPENCODE_DISABLE_MODELS_FETCH"] = "1"

    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end