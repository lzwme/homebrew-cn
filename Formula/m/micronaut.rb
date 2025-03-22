class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.7.6.tar.gz"
  sha256 "f318d884c5062436cd6f58314b8e75cbdbefff6642868026446a304bafb3e6d9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54d6b5d54d270a6424db688e3e130700fb180a7065ee23462930d4ef350cd893"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c90c628efa081dad4dcbbd53dc2469fefd8e8fd9f813f943fb1b78bf379b219a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27ec16b1b2397c4b21520b013a5551c2ba2fc3a0658997c87c7e4d706772681a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd0fafc0563525e62b77a91a74a1d1ca35c5da4fa5c163db14f9b46ad745ceef"
    sha256 cellar: :any_skip_relocation, ventura:       "5fd20b63510e25cf53cadd4c963280a48505a45d20026cda21f6803286f77439"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc3ddb08b4c5f4cfb4bd03170cdfb0f9cd135f60a4d45da760d4a908581065b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fe1e6b689b4393d3e8efddb29f9a6f781cd01d3b74760ca3eef31eead4ce820"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-clibuildexplodedlib"
    (libexec"bin").install "starter-clibuildexplodedbinmn"

    bash_completion.install "starter-clibuildexplodedbinmn_completion" => "mn"
    (bin"mn").write_env_script libexec"binmn", Language::Java.overridable_java_home_env("21")
  end

  test do
    system bin"mn", "create-app", "hello-world"
    assert_predicate testpath"hello-world", :directory?
  end
end