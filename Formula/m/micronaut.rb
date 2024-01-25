class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https:micronaut.io"
  url "https:github.commicronaut-projectsmicronaut-starterarchiverefstagsv4.2.4.tar.gz"
  sha256 "1a2c75e9447380ff7242ae6642f1c8c8ccaf89049fcd8722608be6ac1fc6b4d0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19589bbb206d60d54a16731323ba9e19f7df2691b9f4c3c467a6c288515edaeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "437a4e7619f90320c55879c94ec9017d20334301fc2e1bf83caf6e52528ea28a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8079d2cb02caf6c2349aa001dc419c77ed4acf34b1d82b7b529b3596e0a758f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "221c45ae2bdea1e05b9a880ed1c441da7973cafff6e4b7ad3c8ef329a3a2fd69"
    sha256 cellar: :any_skip_relocation, ventura:        "54b0977431695c2fa2e1de0c9a10cf1debee66d6617a166a1bb6cc719d04b16a"
    sha256 cellar: :any_skip_relocation, monterey:       "97e83bc8e58d9ca9a3327512241d4b27494eddec116137d5c5cd16d3520cef27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec61beebd57cebce01d25dfc8af8fb0caed6e1a29dc6980231b7c2fa0499914b"
  end

  depends_on "gradle" => :build
  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
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