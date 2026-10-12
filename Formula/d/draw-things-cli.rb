class DrawThingsCli < Formula
  desc "Local inference and LoRA training CLI for Draw Things"
  homepage "https://github.com/drawthingsai/draw-things-community"
  url "https://ghfast.top/https://github.com/drawthingsai/draw-things-community/archive/refs/tags/v26.1011.0.tar.gz"
  sha256 "6b17e209f7fc789a0443df92c0812bf8e5ecee72aa41c9f068b9e3a2f080ca0e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36cb95b898f4575cfe46589d703885d9c2b866e6a654c2b637bfdf3825749403"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a10acfe5f5bbbf1f92f80c3e3ee8bfebc1e318e94e53da62f1102c263a47147d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "468e70af69210287ce7c5640eff108f5b8a5b1626d41559f47cb2440fd57c8fb"
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