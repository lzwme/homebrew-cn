class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https:github.comsoulspace-orgoverarch"
  url "https:github.comsoulspace-orgoverarchreleasesdownloadv0.18.0overarch.jar"
  sha256 "06647c6143f177ec7264c1f2ee323d807986004fd5d43cf42cab703e409bf93b"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dddda8347da5bb24789d105e759026af0f3f9d8dc446063379ce5623080a6a8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ecdf81a4c2a181726b5ec16928fabfc7aa0d4b8d652c9985d8b06f1621e19d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b731166e186d539dfda03bc3c215f96f5f09d64e28f1c68f4f4dab4742d6c35"
    sha256 cellar: :any_skip_relocation, sonoma:         "68f5d7536080d82937678a7fc0d9f856ef4a3a29f5694de367cbe992ea95a45c"
    sha256 cellar: :any_skip_relocation, ventura:        "c9bdbca34e666e05833cd0c411a7287913978db2ebaeb78cbd27d6f8606d562b"
    sha256 cellar: :any_skip_relocation, monterey:       "37d62fc3018e6467d7b6d90fe39edc6880865b23dd45a0c66fa9f9853be32c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6226f492f3c13c31f804362bd77d1b6992a1123bd960e1ce47b5ca6751d92e95"
  end

  head do
    url "https:github.comsoulspace-orgoverarch.git", branch: "main"
    depends_on "leiningen" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "lein", "uberjar"
      jar = "targetoverarch.jar"
    else
      jar = "overarch.jar"
    end

    libexec.install jar
    bin.write_jar_script libexec"overarch.jar", "overarch"
  end

  test do
    (testpath"test.edn").write <<~EOS
      \#{
        {:el :person
         :id :test-customer}
        {:el :system
         :id :test-system}
        {:el :rel
         :id :customer-uses-system
         :from :test-customer
         :to :test-system}
        {:el :context-view
         :id :test-context-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}
        {:el :container-view
         :id :test-container-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}}
    EOS
    expected = <<~EOS.chomp
      Model Warnings:
      {:unresolved-refs-in-views (), :unresolved-refs-in-relations ()}
      Model Information:
      {:namespaces {nil 3},
       :relations 1,
       :views-types {:container-view 1, :context-view 1},
       :external {:internal 3},
       :nodes-types {:person 1, :system 1},
       :nodes 2,
       :synthetic {:normal 3},
       :relations-types {:rel 1},
       :views 2}
    EOS
    assert_equal expected, shell_output("#{bin}overarch --model-dir=#{testpath} --model-info").chomp
  end
end