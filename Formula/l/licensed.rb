class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https:github.comgithublicensed"
  url "https:github.comgithublicensed.git",
      tag:      "v5.0.1",
      revision: "d74f3bcf74c241eb79b9b82d7ae3d4bad22bc791"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a93226055833003dfd6f675701b213ea0f0476dcb9f40707c99095e86bb1fcc2"
    sha256 cellar: :any,                 arm64_sonoma:  "752de08cc0b23c00c9fb9c2106d9b96ac5c73f3bd8a88331dc988d9544eb88e7"
    sha256 cellar: :any,                 arm64_ventura: "87d3c13edabbc1ba48f9ace4b8e01f942b6074cc11c98d33e0680af59e715a7d"
    sha256 cellar: :any,                 sonoma:        "38db74e75e7356a2aa0a5a5209b41d76ad75dc34faaf6353eccae3a649963bf3"
    sha256 cellar: :any,                 ventura:       "4728cf574701778fb5545e939aca1030b870b55d04871a7fc6f356b3c4c2f4f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81da36f629c69ed8af2699770ac1f38642b894d54bc38ceada827bc4ba03697d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ruby"
  depends_on "xz"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "licensed.gemspec"
    system "gem", "install", "licensed-#{version}.gem"
    bin.install libexec"binlicensed"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])

    # Avoid references to the Homebrew shims directory
    shims_references = Dir[
      libexec"extensions**rugged-*gem_make.out",
      libexec"extensions**rugged-*mkmf.log",
      libexec"gemsrugged-*vendorlibgit2buildCMakeCache.txt",
      libexec"gemsrugged-*vendorlibgit2build**CMakeFiles***",
    ].select { |f| File.file? f }
    inreplace shims_references,
              Superenv.shims_path.to_s,
              "<**Reference to the Homebrew shims directory**>",
              audit_result: false
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}licensed version").strip

    (testpath"Gemfile").write <<~EOS
      source 'https:rubygems.org'
      gem 'licensed', '#{version}'
    EOS

    (testpath".licensed.yml").write <<~YAML
      name: 'test'
      allowed:
        - mit
    YAML

    assert_match "Caching dependency records for test", shell_output("#{bin}licensed cache")
  end
end