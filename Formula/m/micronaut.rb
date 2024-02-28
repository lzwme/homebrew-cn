class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.3.4.tar.gz"
  sha256 "30426c741050831e9b2d02df0748940bec164e570fba4fdd3cbad81e8531c3a9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cec1e481572322d316d2793c3a9fc5c5469cc40e7f112861ab9f09e7973a3d6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb471fc958fd84c6b7719fdd50ab40267a05972377a2ca63929a2de67a017402"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23f52c8cd176c3b73315949d358b305ad682bc6521c720e1f99194b065d8ada4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a57692631f7402f5ca7829eef8b5d8f6a918e7447e2f5787115ba604f9bbd04"
    sha256 cellar: :any_skip_relocation, ventura:        "df2ffcddf945dae01b2bf33b14fbd7d328a050da77e8accf71a43bf0aeddb16e"
    sha256 cellar: :any_skip_relocation, monterey:       "12c0335bcfc4d2193334f2deb5e366da4e40effb63689df753700de830290856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4705e2d9228000b29e3778dcf5d1513b639c3ee342dfe0428dafc10e9e6536e7"
  end

  depends_on "gradle" => :build
  # jdk21 support issue, https:github.commicronaut-projectsmicronaut-coreissues10046
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-clibuildexplodedlib"
    (libexec"bin").install "starter-clibuildexplodedbinmn"

    bash_completion.install "starter-clibuildexplodedbinmn_completion" => "mn"
    (bin"mn").write_env_script libexec"binmn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}mn", "create-app", "hello-world"
    assert_predicate testpath"hello-world", :directory?
  end
end