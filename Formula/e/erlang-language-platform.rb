class ErlangLanguagePlatform < Formula
  desc "LSP server and CLI for the Erlang programming language"
  homepage "https://whatsapp.github.io/erlang-language-platform/"
  # We require the submodules, so we fetch via git
  url "https://github.com/WhatsApp/erlang-language-platform.git",
      tag:      "2025-12-12",
      revision: "553c90d63143c82057d4888b40109ec9dca2f329"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/WhatsApp/erlang-language-platform.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55661c68b112926c89343e3c2da047d6a0af88da1f17cfe6b65ce244a02d6167"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7177e1f14ee5d6edcf6d68d162045c2e0f7ef43483e99f6f04daf49421bfc6a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "139ac3fc1c8c0ca7ae3ee8730ea0aa7b3cc33dd958c39942bf421b495fa5965a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e34997ea7ddcf9c7506d57f5fd4e44e6c21d7a3ef666b0c388862173078b2f35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c83c4e6f954ef03e2dc925279d0844962432788d751867ebbe71f64529679d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "967a37f1abd84b8e99eba64379d8f4f4904dffff2a88387c83437641bdc3546b"
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
    output = shell_output("#{bin}/elp lint my_module.erl")

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