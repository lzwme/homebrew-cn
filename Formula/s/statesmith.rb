class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https://github.com/StateSmith/StateSmith"
  url "https://ghfast.top/https://github.com/StateSmith/StateSmith/archive/refs/tags/cli-v0.19.0.tar.gz"
  sha256 "62eb44d15a978c82f1ad8a54506f750b76c3dd30ebd1087384366a939a118749"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e93f4b8a25969a81b59a0eeb374fc6c062f8a8af3276f721926d117519438f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16da18559d959ead7b6e22c1af0d1424338c11619ed347d145ff4a151dad0252"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbd75a3a2d138a6448dd30b22e02603d58f0cb15a5a22f5d50ea686205c9dd39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ee04a000fea7bfc26bf67fe5ee3d4d66b68c82b53a75fc087733aea8bdee6f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fb6e2df6189fddea319ff63410c71874a3f599fb06e0cac9b42247ff520409d"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    args = %W[
      -c Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/StateSmith.Cli", *args
    (bin/"ss.cli").write_env_script libexec/"StateSmith.Cli", DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    if OS.mac?
      # We have to do a different test on mac due to https://github.com/orgs/Homebrew/discussions/5966
      # Confirming that it fails as expected per the formula cookbook
      output = pipe_output("#{bin}/ss.cli --version 2>&1")
      assert_match "UnauthorizedAccessException", output
    else
      assert_match version.to_s, shell_output("#{bin}/ss.cli --version")

      File.write("lightbulb.puml", <<~HERE)
        @startuml lightbulb
        [*] -> Off
        Off -> On : Switch
        On -> Off : Switch
        @enduml
      HERE

      shell_output("#{bin}/ss.cli run --lang=JavaScript --no-ask --no-csx -h -b")
      assert_match version.to_s, File.read(testpath/"lightbulb.js")
    end
  end
end