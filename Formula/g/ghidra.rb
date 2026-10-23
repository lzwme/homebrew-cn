class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://ghfast.top/https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.2_build.tar.gz"
  sha256 "ade4fd6e277a10c82db4e75ff5acaeedb3113ef0c7d126ea2c8b38c37128f3c3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1aac5b5a233a97e5cc7aaa485ab3a38204abc003554d5698c47094d7f3991be4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5b5ef3b2186a796649480b040f8969d9cb6ad10332957765f0f6b65ce6b1916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "246d0cefdccdaa545577c940f7ac2394af0c54533d18cb33602fa07d521d3afb"
    sha256 cellar: :any,                 arm64_linux:       "a53fa4a4d316586b48e9963bb020871a30f9875f660c66664eceef2d77e74ddb"
    sha256 cellar: :any,                 x86_64_linux:      "1baef73145ba57161b5832c180647f90e1d0f6d88250d9c3008c9f527846d195"
  end

  depends_on "gradle" => :build
  depends_on "python@3.15" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    inreplace "Ghidra/application.properties", "DEV", "PUBLIC" # Mark as a release
    system "gradle", "-I", "gradle/support/fetchDependencies.gradle"

    system "gradle", "buildNatives"
    system "gradle", "assembleAll"

    libexec.install (buildpath/"build/dist/ghidra_#{version}_PUBLIC").children
    (bin/"ghidraRun").write_env_script libexec/"ghidraRun",
                                       Language::Java.overridable_java_home_env("25")
    (bin/"pyghidraRun").write_env_script libexec/"support/pyghidraRun",
                                         Language::Java.overridable_java_home_env("25")

    # remove incompatible native binaries
    os = OS.mac? ? "mac" : "linux"
    arch = Hardware::CPU.arm? ? "arm_64" : "x86_64"
    (libexec/"GPL/DemanglerGnu/os").children
                                   .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}" }
    (libexec/"Ghidra/Features").glob("{Decompiler,FileFormats}/os/*")
                               .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    (testpath/"analyzeHeadless").write_env_script libexec/"support/analyzeHeadless",
                                                  Language::Java.overridable_java_home_env("25")
    (testpath/"project").mkpath
    system "/bin/bash", testpath/"analyzeHeadless", testpath/"project",
                        "HomebrewTest", "-import", "/bin/bash", "-noanalysis"
    assert_path_exists testpath/"project/HomebrewTest.rep"
  end
end