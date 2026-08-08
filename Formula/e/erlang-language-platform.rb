class ErlangLanguagePlatform < Formula
  desc "LSP server and CLI for the Erlang programming language"
  homepage "https://whatsapp.github.io/erlang-language-platform/"
  # We require the submodules, so we fetch via git
  url "https://github.com/WhatsApp/erlang-language-platform.git",
      tag:      "2026-08-07",
      revision: "53011765c89efe900bb444150858ec6c5535a64f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/WhatsApp/erlang-language-platform.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45cd23f64f98e0daa5bb22a99f1c7e2d3dfcb86948446214d7f55a7ae590d147"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1f01588da6bbef868b2153f94efff76b03b705d9b3f6a2312d13b4751454bb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13d3d7a741d53d245a296dc1b80db1e270785c9745699d7856705b45df4aa21d"
    sha256 cellar: :any_skip_relocation, sonoma:        "33baf923e942af94535f3abd01534e4901e4b5d23bc0b93fa1bc61c0c4e61640"
    sha256 cellar: :any,                 arm64_linux:   "767a35a1330f82b44b1d8a01f81d05370762b1e6a8e611ff457964a87714fae6"
    sha256 cellar: :any,                 x86_64_linux:  "406528c3c3bdb7e06f4d4506d7ab4a090c570226099343b26376cdb03d22f42e"
  end

  depends_on "rust" => :build
  depends_on "sbt" => :build
  depends_on "scala" => :build
  depends_on "erlang"
  depends_on "openjdk"
  depends_on "rebar3"

  def install
    # Build eqwalizer and copy the relevant artifacts to the buildpath
    cd "eqwalizer/eqwalizer" do
      system "sbt", "assembly"
      cp Dir["target/scala-*/eqwalizer.jar"].first, buildpath/"eqwalizer.jar"
    end
    # Build ELP, using the generated artifacts
    ENV["ELP_EQWALIZER_PATH"] = buildpath/"eqwalizer.jar"
    ENV["EQWALIZER_DIR"] = "eqwalizer/eqwalizer_support"
    # The manifest is a workspace manifest, there's nothing "installable"
    build_args = ["build", "--release"]
    system "cargo", *build_args, *std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
    bin.install "target/release/elp"
    generate_completions_from_executable(bin/"elp", "generate-completions")
    bin.env_script_all_files libexec, PATH: "#{formula_opt_bin("erlang")}:${PATH}"
  end

  test do
    # Test version
    assert_match version.to_s, shell_output("#{bin}/elp version")

    # Test ELP diagnostic detection
    (testpath/"my_module.erl").write <<~ERL
      -module(my_module).
      -moduledoc """
      This is a test module.
      """.
      -export([test_function/0]).

      -doc """
      This is a test function
      """.
      test_function() ->
          X = 42,
          ok.
    ERL

    # Run ELP lint to detect diagnostics
    output = shell_output("#{bin}/elp lint")

    # Verify that ELP detected the unused variable diagnostic
    assert_match("variable 'X' is unused", output)

    # Test Eqwalizer integration
    ENV["JAVA_HOME"] = Language::Java.java_home

    (testpath/"my_typed_module.erl").write <<~ERL
      -module(my_typed_module).
      -export([test_function/0]).

      -spec test_function() -> string().
      test_function() ->
          42.
    ERL

    # Run ELP lint to detect diagnostics
    output = shell_output("#{bin}/elp eqwalize my_typed_module")

    # Verify that ELP detected the type mismatch
    assert_match("incompatible_types", output)
  end
end