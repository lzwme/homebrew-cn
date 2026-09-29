class DrawThingsCli < Formula
  desc "Local inference and LoRA training CLI for Draw Things"
  homepage "https://github.com/drawthingsai/draw-things-community"
  url "https://ghfast.top/https://github.com/drawthingsai/draw-things-community/archive/refs/tags/v26.0928.0.tar.gz"
  sha256 "acbce254ff6d7b49ad8ca769f42e6180ded203511d2e73b45072f6db883938d4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c249de59b792714baf3c6213d850e0258dce7abd1a31bf16433ba7e57ded9b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33aa4a2ecff7fc457e3badf9e8ce6c12a9a7c9fd3b559546d892e8bd3b30a6c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a358b050638b6195d18d8baf6c89acd217625d5ca1b9e01be61f7bf1e73f00d2"
  end

  depends_on xcode: ["26.3", :build]
  depends_on macos: :sequoia # aligned to build Xcode as cannot cross-compile

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--product", "draw-things-cli", *std_swift_args
    bin.install ".build/release/draw-things-cli"

    generate_completions_from_executable(bin/"draw-things-cli", "completion")
  end

  test do
    # Point --models-dir into testpath: the default location is outside the
    # test sandbox and depends on host state (Draw Things app container)
    models_dir = testpath/"Models"

    list = shell_output("#{bin}/draw-things-cli models list --downloaded-only --offline --models-dir #{models_dir}")
    assert_match "No models found.", list

    generate = shell_output(
      "#{bin}/draw-things-cli generate --models-dir #{models_dir} --model test --output . --prompt 'test' 2>&1", 64
    )
    assert_match "Error: Could not resolve --model 'test'.", generate
  end
end