cask "android-ndk" do
  version "27c"
  sha256 "7ec95a80d91cda7b4b69401d5c4a4c285fed729811fdf7ceba5739bc9d81e36b"

  url "https:dl.google.comandroidrepositoryandroid-ndk-r#{version}-darwin.dmg",
      verified: "dl.google.comandroidrepository"
  name "Android NDK"
  desc "Toolset to implement parts of Android apps in native code"
  homepage "https:developer.android.comndkindex.html"

  livecheck do
    url "https:developer.android.comndkdownloads"
    regex(Latest\b(?!\s+Beta|\s+Pre-Release).*?r(\d+[a-z]?)i)
  end

  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}ndk_exec.sh"
  preflight do
    Pathname.new("#{HOMEBREW_PREFIX}share").mkpath

    build = File.read("#{staged_path}source.properties").match((?<=Pkg.Revision\s=\s\d\d.\d.)\d+)
    FileUtils.ln_sf("#{staged_path}AndroidNDK#{build}.appContentsNDK", "#{HOMEBREW_PREFIX}shareandroid-ndk")

    File.write shimscript, <<~EOS
      #!binbash
      readonly executable="#{staged_path}AndroidNDK#{build}.appContentsNDK$(basename ${0})"
      test -f "${executable}" && exec "${executable}" "${@}"
    EOS
  end

  %w[
    ndk-build
    ndk-depends
    ndk-gdb
    ndk-stack
    ndk-which
  ].each { |link_name| binary shimscript, target: link_name }

  uninstall delete: "#{HOMEBREW_PREFIX}shareandroid-ndk"

  # No zap stanza required

  caveats <<~EOS
    You may want to add to your profile:
       'export ANDROID_NDK_HOME="#{HOMEBREW_PREFIX}shareandroid-ndk"'
  EOS
end