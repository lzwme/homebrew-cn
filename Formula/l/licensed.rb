class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https:github.comgithublicensed"
  url "https:github.comgithublicensed.git",
      tag:      "v5.0.2",
      revision: "b669a6e0c7298fd33aa0690e9b7f6d539480ca08"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eef38e121fbef0a3b6208c03e6f027d9cdc8a1ed3eb7bc87399914e5bc44ac48"
    sha256 cellar: :any,                 arm64_sonoma:  "9efc2595876e814b0b34786e781e0ad6238982fbc0ba71adbf367c7309b2af29"
    sha256 cellar: :any,                 arm64_ventura: "38dd89df310a68d3e610d22f7748d77237797ffeb7628df94b2aa4093ceb31a5"
    sha256 cellar: :any,                 sonoma:        "503ce1760a956bdbf5a270f3544fb73f336bb0f6ddd02ffc7a1b4816f3cce92d"
    sha256 cellar: :any,                 ventura:       "a9e3679f707cff760e160384f72b8fda83fde2ee547b7e7fd9d1797928edc755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82de8ed73c6e46b473549ebf1ceaaa8e45b229b1ebaec38f2c3dba18aaaab15f"
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