class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https:github.comgithublicensed"
  url "https:github.comgithublicensed.git",
      tag:      "4.4.0",
      revision: "0f5e5a1d289665e8a3d7133cba6c6f3a15359ecb"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b06b95564adc540d4aafc43a2a46168771d2e6b3a748b2c95cc71a79b28b4047"
    sha256 cellar: :any,                 arm64_ventura:  "133d5a34b52686ea4625c9603e3186b3d85fc899dec2a8fc3e8c081554710806"
    sha256 cellar: :any,                 arm64_monterey: "adddccc7895034261c83e2118b66350c17f91cdcc76474149dba1f1505feb299"
    sha256 cellar: :any,                 sonoma:         "a44f7dd570c1ecd7552ced29e76ffcf3e8158b109f767b82c9c793f0451741b9"
    sha256 cellar: :any,                 ventura:        "6e06f31113b06e5ccaa02383fc07d4830dcb03b3d1555e0adccb1a32370948a5"
    sha256 cellar: :any,                 monterey:       "2118b973e3ce647acfb3b1f71f7c51a01e6de9b3f6cc02591cd29183c888e50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159f68bb6f915b6b3c1cdafe24b8f3c304149b70dc508dc3945ece03120019a7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ruby"
  depends_on "xz"

  uses_from_macos "libffi"

  on_linux do
    depends_on "openssl@3"
  end

  # Runtime dependencies of licensed
  # List with `gem install --explain licensed`

  resource "tomlrb" do
    url "https:rubygems.orggemstomlrb-2.0.3.gem"
    sha256 "c2736acf24919f793334023a4ff396c0647d93fce702a73c9d348deaa815d4f7"
  end

  resource "thor" do
    url "https:rubygems.orggemsthor-1.2.2.gem"
    sha256 "2f93c652828cba9fcf4f65f5dc8c306f1a7317e05aad5835a13740122c17f24c"
  end

  resource "ruby-xxHash" do
    url "https:rubygems.orggemsruby-xxHash-0.4.0.2.gem"
    sha256 "201d8305ec1bd0bc32abeaecf7b423755dd1f45f4f4d02ef793b6bb71bf20684"
  end

  resource "racc" do
    url "https:rubygems.orggemsracc-1.6.2.gem"
    sha256 "58d26b3666382396fea84d33dc0639b7ee8d704156a52f8f22681f07b2f94f26"
  end

  # Not listed by `gem install --explain` but required for `nokogiri`
  resource "mini_portile2" do
    url "https:rubygems.orggemsmini_portile2-2.8.4.gem"
    sha256 "180bc4193701bbeb9b6c02df5a6b8185bff7f32abd466dd97d6532d36e45b20a"
  end

  resource "nokogiri" do
    url "https:rubygems.orggemsnokogiri-1.15.4.gem"
    sha256 "e4a801e5ef643cc0036f0a7e93433d18818b31d48c9c287596b68e92c0173c4d"
  end

  resource "reverse_markdown" do
    url "https:rubygems.orggemsreverse_markdown-2.1.1.gem"
    sha256 "b2206466b682ac1177b6b8ec321d00a84fca02d096c5d676a7a0cc5838dc0701"
  end

  resource "pathname-common_prefix" do
    url "https:rubygems.orggemspathname-common_prefix-0.0.1.gem"
    sha256 "d58feac7e5048113dd0c9630af7188baf81d83ab37fdd248fcbc63b9e5da654e"
  end

  resource "parallel" do
    url "https:rubygems.orggemsparallel-1.23.0.gem"
    sha256 "27154713ad6ef32fa3dcb7788a721d6c07bca77e72443b4c6080a14145288c49"
  end

  resource "rugged" do
    url "https:rubygems.orggemsrugged-1.7.1.gem"
    sha256 "11aab9b468a28b784b42afc10444510c3e5a3917b89bb217fcbc0deff4fca90a"
  end

  resource "ruby2_keywords" do
    url "https:rubygems.orggemsruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  resource "faraday-net_http" do
    url "https:rubygems.orggemsfaraday-net_http-3.0.2.gem"
    sha256 "6882929abed8094e1ee30344a3369e856fe34530044630d1f652bf70ebd87e8d"
  end

  resource "faraday" do
    url "https:rubygems.orggemsfaraday-2.7.10.gem"
    sha256 "09be6cf3d4498e31369a8aa0ffde0a4fc3ad4fb9cd5159b1ad65d77421a6eca0"
  end

  resource "public_suffix" do
    url "https:rubygems.orggemspublic_suffix-5.0.3.gem"
    sha256 "337d475da2bd2ea1de0446751cb972ad43243b4b00aa8cf91cb904fa593d3259"
  end

  resource "addressable" do
    url "https:rubygems.orggemsaddressable-2.8.5.gem"
    sha256 "63f0fbcde42edf116d6da98a9437f19dd1692152f1efa3fcc4741e443c772117"
  end

  resource "sawyer" do
    url "https:rubygems.orggemssawyer-0.9.2.gem"
    sha256 "fa3a72d62a4525517b18857ddb78926aab3424de0129be6772a8e2ba240e7aca"
  end

  resource "octokit" do
    url "https:rubygems.orggemsoctokit-6.1.1.gem"
    sha256 "920e4a9d820205f70738f58de6a7e6ef0e2f25b27db954b5806a63105207b0bf"
  end

  resource "dotenv" do
    url "https:rubygems.orggemsdotenv-2.8.1.gem"
    sha256 "c5944793349ae03c432e1780a2ca929d60b88c7d14d52d630db0508c3a8a17d8"
  end

  resource "licensee" do
    url "https:rubygems.orggemslicensee-9.16.0.gem"
    sha256 "7b1693639019dbb1d3e020d72c4470ca84da3cfc67e4d6da1d1cdcb736d09044"
  end

  resource "json" do
    url "https:rubygems.orggemsjson-2.6.3.gem"
    sha256 "86aaea16adf346a2b22743d88f8dcceeb1038843989ab93cda44b5176c845459"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      args = ["--ignore-dependencies", "--no-document", "--install-dir", libexec]
      system "gem", "install", r.cached_download, *args
    end

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
    inreplace shims_references, Superenv.shims_path.to_s, "<**Reference to the Homebrew shims directory**>", false
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}licensed version").strip

    (testpath"Gemfile").write <<~EOS
      source 'https:rubygems.org'
      gem 'licensed', '#{version}'
    EOS

    (testpath".licensed.yml").write <<~EOS
      name: 'test'
      allowed:
        - mit
    EOS

    assert_match "Caching dependency records for test",
                        shell_output(bin"licensed cache")
  end
end